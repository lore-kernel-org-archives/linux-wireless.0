Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:53048 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdKJVIZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Nov 2017 16:08:25 -0500
Date: Fri, 10 Nov 2017 22:08:19 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/6] firmware: Add request_firmware_prefer_user()
 function
Message-ID: <20171110210819.ogupue5wlzm2ar3i@pali> (sfid-20171110_220846_726124_BDFE2A90)
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-6-git-send-email-pali.rohar@gmail.com>
 <20171110202601.GR22894@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20171110202601.GR22894@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 November 2017 21:26:01 Luis R. Rodriguez wrote:
> On Fri, Nov 10, 2017 at 12:38:27AM +0100, Pali Rohár wrote:
> > This function works pretty much like request_firmware(), but it prefer
> > usermode helper. If usermode helper fails then it fallback to direct
> > access. Useful for dynamic or model specific firmware data.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > ---
> >  drivers/base/firmware_class.c |   45 +++++++++++++++++++++++++++++++++++++++--
> >  include/linux/firmware.h      |    9 +++++++++
> >  2 files changed, 52 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index 4b57cf5..c3a9fe5 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -195,6 +195,11 @@ static int __fw_state_check(struct fw_state *fw_st, enum fw_status status)
> >  #endif
> >  #define FW_OPT_NO_WARN	(1U << 3)
> >  #define FW_OPT_NOCACHE	(1U << 4)
> > +#ifdef CONFIG_FW_LOADER_USER_HELPER
> > +#define FW_OPT_PREFER_USER	(1U << 5)
> > +#else
> > +#define FW_OPT_PREFER_USER	0
> > +#endif
> 
> I've been cleaning these up these flags [0], which I'll shortly respin based
> on feedback, so this sort of stuff should be avoided at all costs.
> 
> Regardless of this even if you *leave* the flag in place and a driver required
> this, but the kernel was compiled without CONFIG_FW_LOADER_USER_HELPER then
> calling fw_load_from_user_helper would just already return -ENOENT, as such it
> would in turn fallback to direct fs loading so the #ifef'ery seems to be not
> needed.
> 
> [0] https://lkml.kernel.org/r/20170914225422.31034-1-mcgrof@kernel.org
> 
> >  struct firmware_cache {
> >  	/* firmware_buf instance will be added into the below list */
> > @@ -1214,13 +1219,26 @@ static void fw_abort_batch_reqs(struct firmware *fw)
> >  	if (ret <= 0) /* error or already assigned */
> >  		goto out;
> >  
> > -	ret = fw_get_filesystem_firmware(device, fw->priv);
> > +	if (opt_flags & FW_OPT_PREFER_USER) {
> > +		ret = fw_load_from_user_helper(fw, name, device, opt_flags, timeout);
> > +		if (ret && !(opt_flags & FW_OPT_NO_WARN)) {
> > +			dev_warn(device,
> > +				 "User helper firmware load for %s failed with error %d\n",
> > +				 name, ret);
> > +			dev_warn(device, "Falling back to direct firmware load\n");
> 
> As I had noted before, the usermode helper was really not well designed,
> as such extending further use of it is something we should shy away unless we
> determine its completely necessary.
> 
> So what's wrong with this driver failing at direct access, which should be fast,
> and relying on a uevent to then work using the current fallback mechanisms?
> 
> The commit log in no way documents any of the justifications for further
> extending use of the usermode helper.

Hi! See patch 6/6. It is needed to avoid direct access and wl1251 on
Nokia N900 needs to use userspace helper which prepares firmware data.

Direct access is just fallback when userspace helper is not available.
Without userspace helper on devices where wl1251 do not have own eeprom
memory, wl1251 cannot work.

I know that usermode helper is not well designed, but it is the best
option what we can do for wl1251.

-- 
Pali Rohár
pali.rohar@gmail.com
