Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr9.hinet.net ([168.95.4.109]:39997 "EHLO msr9.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1GPDXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 23:23:09 -0400
Date: Sat, 16 Jul 2011 11:21:01 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: r8712u: Most return-values changed from
 -1 to proper errno macros.
Message-ID: <20110716032100.GA3274@internetdog.org> (sfid-20110716_052314_044149_767D9ADD)
Reply-To: ali@internetdog.org
References: <20110703010605.GA3736@internetdog.org>
 <1310749876-32632-1-git-send-email-ali@internetDog.org>
 <1310749876-32632-2-git-send-email-ali@internetDog.org>
 <4E20AA5A.6020101@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E20AA5A.6020101@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 04:00:10PM -0500, Larry Finger wrote:
> On 07/15/2011 12:11 PM, Ali Bahar wrote:
> >The ioctl handlers were frequently returning -1 upon failure. Most of
> >these have now been changed to proper errno macros.
> >The few remaining ones have been left untouched because either the
> >handler is not called (and so cannot be tested), or the function never
> >fails (and so cannot be system-tested), or requires new code to
> >distinguish its failures.
> >
> >Signed-off-by: Ali Bahar<ali@internetDog.org>
> >Cc: Larry Finger<Larry.Finger@lwfinger.net>
> >---
> >  drivers/staging/rtl8712/rtl871x_ioctl_linux.c |  121 +++++++++++++++++++++----
> >  1 files changed, 105 insertions(+), 16 deletions(-)
> >
> >diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> >index 40e6b5c..bb97d8b 100644
> >--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> >+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> >@@ -526,7 +526,7 @@ static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
> >  		memcpy(buf, pie , ielen);
> >  		pos = buf;
> >  		if (ielen<  RSN_HEADER_LEN) {
> >-			ret  = -1;
> >+			ret  = -EINVAL;
> >  			goto exit;
> >  		}
> >  		if (r8712_parse_wpa_ie(buf, ielen,&group_cipher,
> >@@ -689,6 +689,11 @@ static const long frequency_list[] = {
> >  	5825
> >  };
> >
> >+/*
> >+ * This function intends to handle the Set Freq command.
> >+ * Currently, the request comes via the Wireless Extensions' SIOCSIWFREQ ioctl.
> >+ *
> >+ */
> 
> This comment is not needed. The function name is descriptive and it
> is clear that it is part of WEXT.

OK.
See below.



> >  static int r8711_wx_set_mode(struct net_device *dev,
> >  			     struct iw_request_info *a,
> >  			     union iwreq_data *wrqu, char *b)
> >@@ -769,10 +789,15 @@ static int r8711_wx_set_mode(struct net_device *dev,
> >  	else
> >  		r8712_setopmode_cmd(padapter, Ndis802_11AutoUnknown);
> >  	if (!r8712_set_802_11_infrastructure_mode(padapter, networkType))
> >-		return -1;
> >+		return -EPERM; /* Unknown failure. */
> >  	return 0;
> 
> As r8712_set_802_11_infrastructure_mode() always returns true. it
> would be better to rewrite it as a void function and completely do
> away with the test here.

Agreed. I was going to wait till after the/any merge with Realtek's
latest. Instead, I'll do it now.
Similarly with the other such checks.




> Comments in the Linux kernel are relatively rare. Only things that
> are not immediately obvious should receive special annotation.

I'll undo all the comments.

Please don't interpret the following as the start of a debate on
commenting Linux; it's not my place to do so. I'm just explaining, for
public record, why the above was done.

I am aware of the current state of the Linux code's documentation.
Habitually, I comment the big-picture as I go along. Industry practice
wrt comments differs from Linux's, of course.
The comments were in the function heads, not in the bodies, as per
Documentation/CodingStyle. 
The big-picture of the functions is clear once you are familiar enough
to begin to modify the code. However, and especially for linux, code
is read a thousand times for every time it is written. Most eyeballs
could do with a line or two of explanation.
To me, Documentation/kernel-docs.txt echoed the need for a
big-picture view.
If the goal is to attract more developers (as it is at least Greg KH's
intent), then Linux's code-base has a long way to go. I meant only to
start chipping away at the task.


Anyways. Didn't mean to give you a headache.


> 
> Larry

Thank you for taking the time. Greatly appreciated.

BTW, if there's any particular work that you feel this driver needs,
do let me know. I've planned to look at the latest Reaktek code for
potential merges, and then see if I can interface it with iw
(cfg80211.) I'll also dig to see what it may take to add monitor-mode
to this.
Any such patches will be posted to the Staging ML.

regards,
ali
