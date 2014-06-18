Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51583 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaFRVo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 17:44:29 -0400
Received: by mail-pd0-f178.google.com with SMTP id r10so1097758pdi.37
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2014 14:44:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402778536-31305-1-git-send-email-mihirsht@gmail.com>
References: <1402778536-31305-1-git-send-email-mihirsht@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 18 Jun 2014 14:44:07 -0700
Message-ID: <CAB=NE6U=i7oeK7Ue=NH2YFhLrZOc359MzRYcj4Cv2dYUC0QwmQ@mail.gmail.com> (sfid-20140618_234432_697004_8D991DF3)
Subject: Re: [PATCH] cfg80211: unblock user hint when cfg80211_regdom is intersected
To: Mihir Shete <mihirsht@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 14, 2014 at 1:42 PM,  <mihirsht@gmail.com> wrote:
> From: Mihir Shete <mihirsht@gmail.com>
>
> User hints are always ignored if cfg80211_regdom is intersected.
> Add checks to make sure that user hints are processed if the
> previous hints are done processing.
>
> Signed-off-by: Mihir Shete <mihirsht@gmail.com>
> ---
>  net/wireless/reg.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index b4973bc..2c4e2ba 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -396,6 +396,14 @@ static bool regdom_changes(const char *alpha2)
>         return !alpha2_equal(r->alpha2, alpha2);
>  }
>
> +static bool is_cfg80211_regdom_intersected(void)
> +{
> +       const struct ieee80211_regdomain *r = get_cfg80211_regdom();
> +
> +       if (!r)
> +               return false;
> +       return is_intersected_alpha2(r->alpha2);
> +}

Shouldn't this just be the last request->intersect too ?

>  /*
>   * The NL80211_REGDOM_SET_BY_USER regdom alpha2 is cached, this lets
>   * you know if a valid regulatory hint with NL80211_REGDOM_SET_BY_USER
> @@ -1650,9 +1658,14 @@ __reg_process_hint_user(struct regulatory_request *user_request)
>          */
>         if ((lr->initiator == NL80211_REGDOM_SET_BY_CORE ||
>              lr->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
> -            lr->initiator == NL80211_REGDOM_SET_BY_USER) &&
> -           regdom_changes(lr->alpha2))
> -               return REG_REQ_IGNORE;
> +            lr->initiator == NL80211_REGDOM_SET_BY_USER)) {
> +               if (lr->intersect) {
> +                       if (!is_cfg80211_regdom_intersected())
> +                               return REG_REQ_IGNORE;

Let's keep this in mind:

When processing requests on the queue get_last_request() will return
the last requests which was accepted and already processed. When
reg_update_last_request() is issued last_request becomes the newly
accepted request that we are about to process. If this seems rather
confusing we should split this up into two, but so far its not clear
to me this is needed given we serialize processing requests and have a
last_request->pending too.

__reg_process_hint_user() is evaluating whether or not we should apply
the passed hint. Given all this, when would lr->intersect be true but
the set regdomain not be intersected? That would seem like an issue to
me.

Also note that your commit log seems to claim to want to make a change
only for user type hints but the above folds all your desired changes
to all the checks it was checking for.

Lastly, we should be allowing through user changes if and only if a
core or driver hint was not issued, otherwise the intersection makes
sense to upkeep, however I do see it making sense to allow a user
regulatory if an intersection was done but *iff* we want to clear the
old userspace setting, but note that to do that cleanly we'd have to
assume an original state. We can do this without much overhead by
resetting the regulatory core to the original state given that core
and driver hints will be cached and be set once the reset is called.
You have to consider when a reset makes sense though and be very very
careful about this though otherwise you might end up in inconsistent
states that make no sense at run time. Consider being allowed to do
certain things, being associated, and then all of a sudden driving the
regulatory core which would prohibit that current state.

If you really want to enable this regardless of the state you may have
to trigger disassoc, etc. Please think of all this.

NACK for now.

  Luis
