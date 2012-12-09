Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:40702 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756812Ab2LIScT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 13:32:19 -0500
Message-ID: <1355077939.19224.25.camel@joe-AO722> (sfid-20121209_193223_046966_A5D7EC2B)
Subject: Re: [PATCH V2 05/11] brcmfmac: error messages should not be
 suppressed
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Date: Sun, 09 Dec 2012 10:32:19 -0800
In-Reply-To: <50C05B64.5050702@broadcom.com>
References: <1354717564-7183-6-git-send-email-arend@broadcom.com>
	 <1354742910-8822-1-git-send-email-arend@broadcom.com>
	 <1354775578.8320.26.camel@joe-AO722> <50C05B64.5050702@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-06 at 09:46 +0100, Arend van Spriel wrote:
> On 12/06/2012 07:32 AM, Joe Perches wrote:
> > On Wed, 2012-12-05 at 22:28 +0100, Arend van Spriel wrote:
> >> The call to brcmf_dbg(ERROR, ...) only resulted in a log message
> >> when compiled with -DDEBUG. Error messages are valuable for resolving
> >> issues so this patch replaces it with brcmf_err(...) so they always
> >> end up in the log.
> > []
> > 
> >> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
> > []
> >> @@ -35,20 +34,11 @@
> >>  
> >>  #if defined(DEBUG)
> >>  
> >> -#define brcmf_dbg(level, fmt, ...)					\
> >> -do {									\
> >> -	if (BRCMF_ERROR_VAL == BRCMF_##level##_VAL) {			\
> >> -		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
> >> -			if (net_ratelimit())				\
> >> -				pr_debug("%s: " fmt,			\
> >> -					 __func__, ##__VA_ARGS__);	\
> >> -		}							\
> >> -	} else {							\
> >> -		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
> >> -			pr_debug("%s: " fmt,				\
> >> -				 __func__, ##__VA_ARGS__);		\
> >> -		}							\
> >> -	}								\
> >> +#define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
> > 
> > You still lost the net_ratelimit() for the DEBUG case.
> > 
> > This brcmf_err macro should probably be in dhd.h,
> > not in a debug header and not guarded by DEBUG at all.
> 
> I thought I explained why in my email response to you, but now I don't
> see that one on the mailing list archives (attached now). When we are
> debugging we do not want error messages to be filtered.

I suppose that depends on how flooded the dmesg log
could be by these.  I presumed that because all
brcmf_dbg uses were debug only messages, and only
BRCMF_ERROR_VAL messages were rate limited, then it
was because flooding these messages at debug wasn't
useful.

I presume that's still true.


