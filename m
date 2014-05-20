Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:61842 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaETH1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:27:49 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so53237lbi.9
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 00:27:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399622690-7202-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1399622690-7202-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 00:27:26 -0700
Message-ID: <CAB=NE6Va3XDbUSUi1jk8-EHM8xdcLntU_9_9F0AnUJLkV3PFwA@mail.gmail.com> (sfid-20140520_092751_466972_3EE0CAF8)
Subject: Re: [PATCH v2] cfg80211: reg: track crda request
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 9, 2014 at 1:04 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> @@ -1803,6 +1807,9 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>         struct wiphy *wiphy = NULL;
>         enum reg_request_treatment treatment;
>
> +       REG_DBG_PRINT("Process regulatory hint called by %s\n",

"Processing"

> +                     reg_initiator_name(reg_request->initiator));
> +
>         if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
>                 wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
>
> @@ -1811,12 +1818,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>                 reg_process_hint_core(reg_request);
>                 return;
>         case NL80211_REGDOM_SET_BY_USER:
> -               treatment = reg_process_hint_user(reg_request);
> -               if (treatment == REG_REQ_IGNORE ||
> -                   treatment == REG_REQ_ALREADY_SET)
> -                       return;
> -               queue_delayed_work(system_power_efficient_wq,
> -                                  &reg_timeout, msecs_to_jiffies(3142));
> +               reg_process_hint_user(reg_request);

You do something more than your commit log says it does, in this case
its ignoring REG_REQ_IGNORE and REG_REQ_ALREADY_SET, explain why that
is being done, that is very important part of this change.

For example you want to explain that we typically never allowed
retries on the same regulatory hint, but this makes sense in the
corner case of udev not picking sending hints to CRDA as CRDA may be
on a partition not mounted yet. It would also be good for you to do
homework on whether or not udev with systemd guarantees rules using a
binary on a path will get all its queued up stuff only sent to it once
the partition it could be on is available. This is the right long term
solution to this and we need to be mindful of it. If you find that
systemd+udev will ensure proper synchronization then you can then say
that this timeout is only then important for legacy systems, if its
not we should look to see if we can add udev synchronization for
depending binaries used on rules.

>                 return;
>         case NL80211_REGDOM_SET_BY_DRIVER:
>                 if (!wiphy)
> @@ -2608,9 +2610,40 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
>
>  static void reg_timeout_work(struct work_struct *work)
>  {
> -       REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
> +       struct regulatory_request *lr;
> +
>         rtnl_lock();
> -       restore_regulatory_settings(true);
> +
> +       lr = get_last_request();
> +       REG_DBG_PRINT("Timeout while waiting for CRDA to reply %s request\n",
> +                     reg_initiator_name(lr->initiator));
> +
> +       switch (lr->initiator) {
> +       case NL80211_REGDOM_SET_BY_CORE:
> +       case NL80211_REGDOM_SET_BY_DRIVER:
> +#ifdef CONFIG_CFG80211_INTERNAL_REGDB

Can you use config_enabled(CONFIG_CFG80211_INTERNAL_REGDB) instead ?

> +               pr_warn("invalid db.txt file, will use limited/restricted regulatory settings\n");
> +               break;
> +#else

There is a different between CRDA not being available (we'd know if
CRDA was present once if at least for one call it was successful, but
note we don't yet distinguish the source of a regulatory domain
successful call, whether its from the internal db or not, and a change
for this is welcomed, although note that upon  restore regulatory
settings call we could be coming back from a suspend/resume remount),
a specific alpha2 not being available, and an alpha2 not being
available on the internal regdb, the above and below does not
distinguish any of this and it seems it should. If it proves to be
adding quite a bit of code, don't worry -- splitting this up into
separate calls for each case might make this code more manageable, at
least that's what happened with the processing of regulatory hints,
leave it up to you as you see the code as modify it to handle the
different cases I just outlined.

> +               if (lr->crda_call_count < REG_CRDA_CALL_COUNT_MAX) {
> +                       /* Call CRDA again for last request */
> +                       lr->crda_call_count++;
> +                       reg_process_hint(lr);

A comment specifying the things I mentioned about udev could be useful
here, but it'd be a bit nicer if this was instead just properly
documented on the crda_call_count variable enum documentation, then
you can go to town on the documentation there.

> +               } else
> +                       pr_warn("CRDA not available, will use limited/restricted regulatory settings\n");
> +
> +               break;
> +#endif /* CONFIG_CFG80211_INTERNAL_REGDB */
> +       case NL80211_REGDOM_SET_BY_USER:
> +               restore_regulatory_settings(true);
> +               break;
> +       case NL80211_REGDOM_SET_BY_COUNTRY_IE:
> +               restore_regulatory_settings(false);
> +               break;
> +       default:
> +               WARN_ON(1);
> +               break;

I'd prefer to leave this one out and instead let the compiler deal
with compilation warning about the switch not handling new cases,
which it does today because of the enum.

  Luis
