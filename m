Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:45364 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0EZFHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 01:07:25 -0400
Subject: Re: [PATCH] cfg80211: Fix user-space crda query stall
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinMo6L_LuCgcu9izxUVsFbi7kamHD2F_xThwJ2R@mail.gmail.com>
References: <1274770211-22710-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274770211-22710-2-git-send-email-juuso.oikarinen@nokia.com>
	 <AANLkTinMo6L_LuCgcu9izxUVsFbi7kamHD2F_xThwJ2R@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 08:08:39 +0300
Message-ID: <1274850519.5277.1413.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-25 at 21:02 +0200, ext Luis R. Rodriguez wrote:
> On Mon, May 24, 2010 at 11:50 PM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > The userspace crda utility can fail to respond to kernel requests in (at least)
> > two scenarios: it is not runnable for any reason, or it is invoked with a
> > country code not in its database.
> >
> > When the userspace crda utility fails to respond to kernel requests (i.e. it
> > does not use NL80211_CMD_SET_REG to provide the kernel regulatory information
> > for the requested country) the kernel crda subsystem will stall. It will
> > refuse to process any further regulatory hints. This is easiest demonstrated
> > by using for instance the "iw" tool:
> >
> >   iw reg set EU
> >   iw reg set US
> >
> > "EU" is not a country code present in the database, so user space crda will
> > not respond. Attempting to define US after that will be silently ignored
> > (internally, an -EAGAIN is the result, as the "EU" request is still
> > "being processed".)
> >
> > To fix this issue, this patch implements timeout protection for the userspace
> > crda invocation. If there is no response for five seconds, the crda code will
> > force itself to the world regulatory domain for maximum safety.
> >
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> This is a great idea, I really like it and appreciate you taking the
> time to work on this, however to do this it requires a little more
> work and will point out the notes below. So NACK for now but with some
> fixes I think this would be great.
> 
> > ---
> >  net/wireless/reg.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 44 insertions(+), 0 deletions(-)
> >
> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > index 8f0d97d..6c945f0 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -385,6 +385,40 @@ static inline void reg_regdb_query(const char *alpha2) {}
> >  #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
> >
> >  /*
> > + * This gets invoked if crda in userspace is not responding (it's not getting
> > + * executed or the country code in the hint is not in the database.
> > + */
> > +
> > +static void call_crda_timeout_work(struct work_struct *work)
> > +{
> > +       if (!last_request)
> > +               return;
> > +
> > +       printk(KERN_INFO "cfg80211: crda request timed out, reverting to 00\n");
> > +
> > +       mutex_lock(&cfg80211_mutex);
> > +
> > +       /*
> > +        * As we are not getting data for the current country, force us back
> > +        * to the world regdomain.
> > +        */
> > +       last_request->alpha2[0] = '0';
> > +       last_request->alpha2[1] = '0';
> > +       set_regdom(cfg80211_world_regdom);
> > +       mutex_unlock(&cfg80211_mutex);
> > +}
> 
> 
> Actually you may want to consider using restore_regulatory_settings()
> instead as that would:
> 
>   * set the world regdom
>   * then set the first user specified regulatory domain if they had one picked
> 
> This would mean we would go into a loop here though if the user had
> specified 'EU' though so this routine first needs to be fixed to
> annotate a regulatory domain as invalid. Note that a regulatory cannot
> be invalid if CRDA just times out -- CRDA could time out if it was not
> present. So this is a bit tricky and not sure how to resolve it. John
> recently added support for building the regulatory database as part of
> the kernel but at the same time support letting CRDA still update the
> same info if it is present. Then for those setup it could be possible
> 'DE' exists on the core kernel regulatory database but if CRDA is not
> installed then CRDA will time out.
> 
> Maybe what we can do is if both the internal kernel regdb *and* CRDA
> times out then mark the user specified request as invalid and restore
> to using the world regdom. This would allow the user to later install
> a CRDA with some newer regdb in userspace, for example. This allows
> for upgrading the db itself from userspace without making kernel
> changes. It allows for countries to be created.

Sounds fair. Here's my initial thought: 

I will look into adding validation of the country code with the kernel
internal database if the db is enabled in the config - in which case we
proceed as you describe. In case the internal db is disabled in the
config, we proceed as the patch currently does?

Would that sound like an acceptable approach?

-Juuso

> 
> > +
> > +static DECLARE_WORK(crda_uevent_timeout_work, call_crda_timeout_work);
> > +
> > +#define CRDA_UEVENT_TIMEOUT 5000
> > +static void crda_uevent_timeout(unsigned long data)
> > +{
> > +       schedule_work(&crda_uevent_timeout_work);
> > +}
> > +
> > +static DEFINE_TIMER(crda_uevent_timer, crda_uevent_timeout, 0, 0);
> 
> I would prefer we use a completion here, seems a little cleaner. Check
> out ath9k/wmi.c for cmd_wait and its use with init_completion() and
> complete().
> 
> > +/*
> >  * This lets us keep regulatory code which is updated on a regulatory
> >  * basis in userspace.
> >  */
> > @@ -409,6 +443,10 @@ static int call_crda(const char *alpha2)
> >        country_env[8] = alpha2[0];
> >        country_env[9] = alpha2[1];
> >
> > +       /* start timeout timer */
> > +       mod_timer(&crda_uevent_timer,
> > +                 jiffies + msecs_to_jiffies(CRDA_UEVENT_TIMEOUT));
> > +
> >        return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, envp);
> >  }
> >
> > @@ -2581,6 +2619,9 @@ int set_regdom(const struct ieee80211_regdomain *rd)
> >
> >        assert_cfg80211_lock();
> >
> > +       /* cancel timeout */
> > +       del_timer(&crda_uevent_timer);
> > +
> >        mutex_lock(&reg_mutex);
> >
> >        /* Note that this doesn't update the wiphys, this is done below */
> > @@ -2683,6 +2724,9 @@ void regulatory_exit(void)
> >
> >        cancel_work_sync(&reg_work);
> >
> > +       del_timer_sync(&crda_uevent_timer);
> > +       cancel_work_sync(&crda_uevent_timeout_work);
> > +
> >        mutex_lock(&cfg80211_mutex);
> >        mutex_lock(&reg_mutex);
> 
> Thanks!!!
> 
>   Luis


