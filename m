Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36821
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761663Ab2C3VYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 17:24:51 -0400
Date: Fri, 30 Mar 2012 17:24:42 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lf_driver_backport@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] compat: fix extreme build slowdowns
Message-ID: <20120330212442.GC11929@bombadil.infradead.org> (sfid-20120330_232509_575087_D91A4984)
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net>
 <20341.39041.645223.592030@gargle.gargle.HOWL>
 <1333107022.3908.16.camel@jlt3.sipsolutions.net>
 <4F75C634.1010400@gmail.com>
 <CAB=NE6XbYMo=or0QLKw3-w5rbnMkwvxRntaRPK6O=LeYT-nkeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAB=NE6XbYMo=or0QLKw3-w5rbnMkwvxRntaRPK6O=LeYT-nkeA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 30, 2012 at 01:43:20PM -0700, Luis R. Rodriguez wrote:
> On Fri, Mar 30, 2012 at 7:41 AM, Richard Farina <sidhayn@gmail.com> wrote:
> > On 03/30/12 07:30, Johannes Berg wrote:
> >> On Fri, 2012-03-30 at 16:56 +0530, Sujith Manoharan wrote:
> >>> Johannes Berg wrote:
> >>>> Somehow exporting too many variables completely confuses the kernel's
> >>>> Makefiles into trying to calculate the size of every file in a very slow
> >>>> shell script ... this is causing EXTREME build slowdowns for me.
> >>>>
> >>>> These two patches fix it.
> >>> Nice.
> >>>
> >>> Trying to build ath9k..
> >>>
> >>> Before:
> >>>
> >>> real    1m18.689s
> >>> user    3m1.382s
> >>> sys     0m6.833s
> >>>
> >>> After:
> >>>
> >>> real    0m42.091s
> >>> user    1m30.024s
> >>> sys     0m5.700s
> > Please put this in stable as well, seems like a good thing ;-)
> 
> Johannes, kick ass patches, thanks!!! Richard, I will propagate to
> stable, but first gotta figure why the patch, "compat: explicitly
> export generated variables" broke builds for older kernels:
> 
> mcgrof@tux ~/compat (git::master)$ ckmake
> Trying kernel                  3.3.0-030300rc2-generic	[OK]
> Trying kernel                     3.2.2-030202-generic	[OK]
> Trying kernel                    3.1.10-030110-generic	[OK]
> Trying kernel                    3.0.18-030018-generic	[OK]
> Trying kernel                  2.6.39-02063904-generic	[OK]
> Trying kernel                        2.6.38-13-generic	[OK]
> Trying kernel                  2.6.38-02063808-generic	[OK]
> Trying kernel                  2.6.37-02063706-generic	[OK]
> Trying kernel                  2.6.36-02063604-generic	[OK]
> Trying kernel                  2.6.35-02063512-generic	[OK]
> Trying kernel                  2.6.34-02063410-generic	[OK]
> Trying kernel                  2.6.33-02063305-generic	[OK]
> Trying kernel                  2.6.32-02063255-generic	[FAILED]
> Trying kernel                        2.6.31-22-generic	[FAILED]
> Trying kernel                  2.6.31-02063113-generic	[FAILED]
> Trying kernel                  2.6.30-02063010-generic	[FAILED]
> Trying kernel                  2.6.29-02062906-generic	[FAILED]
> Trying kernel                  2.6.28-02062810-generic	[FAILED]
> Trying kernel                    2.6.27-020627-generic	[FAILED]
> Trying kernel                    2.6.26-020626-generic	[FAILED]
> Trying kernel                    2.6.25-020625-generic	[FAILED]
> Trying kernel                    2.6.24-020624-generic	[FAILED]

Applying this patch prior to yours fixes it:

diff --git a/compat/compat_firmware_class.c b/compat/compat_firmware_class.c
index 01eda40..69b442b 100644
--- a/compat/compat_firmware_class.c
+++ b/compat/compat_firmware_class.c
@@ -635,7 +635,7 @@ out:
  *      firmware image for this or any other device.
  **/
 int
-request_firmware(const struct firmware **firmware_p, const char *name,
+compat_request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
         int uevent = 1;
@@ -646,7 +646,7 @@ request_firmware(const struct firmware **firmware_p, const char *name,
  * release_firmware: - release the resource associated with a firmware image
  * @fw: firmware resource to release
  **/
-void release_firmware(const struct firmware *fw)
+void compat_release_firmware(const struct firmware *fw)
 {
 	if (fw) {
 		if (!fw_is_builtin_firmware(fw))
@@ -705,7 +705,7 @@ static int request_firmware_work_func(void *arg)
  *	in atomic contexts.
  **/
 int
-request_firmware_nowait(
+compat_request_firmware_nowait(
 	struct module *module, int uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index c900a6f..a11d80f 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -37,7 +37,7 @@ static inline int compat_request_firmware(const struct firmware **fw,
 {
 	return -EINVAL;
 }
-static inline int request_firmware_nowait(
+static inline int compat_request_firmware_nowait(
 	struct module *module, int uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
