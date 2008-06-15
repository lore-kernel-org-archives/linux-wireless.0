Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:36412 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbYFOQrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 12:47:11 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3230734rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jun 2008 09:47:10 -0700 (PDT)
Date: Sun, 15 Jun 2008 09:46:17 -0700
From: Joonwoo Park <joonwpark81@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, Tomas Winkler <tomasw@gmail.com>,
	JMF <tolas_feup@hotmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
Message-ID: <20080615164617.GA27699@tp64> (sfid-20080615_184714_995522_39373628)
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com> <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com> <loom.20080527T105701-941@post.gmane.org> <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com> <1211896423.1746.9.camel@localhost.localdomain> <20080528004100.GG7779@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080528004100.GG7779@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2008 at 08:41:00PM -0400, John W. Linville wrote:
> On Tue, May 27, 2008 at 09:53:43AM -0400, Dan Williams wrote:
> 
> > I've gotten maybe 1 or 2 requests for > 104/128-bit WEP key support for
> > NM in 3 years.  Nice to have, but I'm not sure it's worth the extra code
> > and maintenance burden?  Would be good to have somebody tell us what
> > hardware (APs and cards) support this though.
> 
> I'm inclined to think that it is _not_ worth the trouble for this
> particular feature.
> 
> John

This patch limits wep key size to 128/104-bits.
I hope you guys like this.

Thanks,

Joonwoo

---
[PATCH] wireless: Limit wep key size to 128/104-bits

This patch prevents overflow which is occured by invalid long wep key
insertion

$sudo iwconfig wlan0 enc AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [memcpy_c+0xb/0x20] memcpy_c+0xb/0x20
PGD 13a590067 PUD 12e471067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 1
...
Pid: 10, comm: events/1 Not tainted 2.6.26-rc2 #9
...
Call Trace:
 [iwl4965:iwl4965_rx_scan_start_notif+0xb/0x20] ? :iwl4965:iwl4965_enqueue_hcmd+0x12b/0x220
 [hci_usb:init_module+0xe97/0x28cb0] :iwlcore:iwl_send_cmd_sync+0x67/0x290
 [save_trace+0x3f/0xb0] ? save_trace+0x3f/0xb0
...

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 net/wireless/wext.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/wireless/wext.c b/net/wireless/wext.c
index 947188a..c8ef55b 100644
--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -102,6 +102,8 @@
 
 #include <asm/uaccess.h>		/* copy_to_user() */
 
+#define KEY_SIZE_WEP104		13
+
 /************************* GLOBAL VARIABLES *************************/
 /*
  * You should not use global variables, because of re-entrancy.
@@ -740,8 +742,8 @@ static int ioctl_standard_call(struct net_device *	dev,
 		 * for max space. Easier, and won't last long... */
 		extra_size = descr->max_tokens * descr->token_size;
 
-		/* Check need for ESSID compatibility for WE < 21 */
 		switch (cmd) {
+		/* Check need for ESSID compatibility for WE < 21 */
 		case SIOCSIWESSID:
 		case SIOCGIWESSID:
 		case SIOCSIWNICKN:
@@ -761,6 +763,13 @@ static int ioctl_standard_call(struct net_device *	dev,
 					essid_compat = 1;
 			}
 			break;
+
+		/* Limit wep key size to 128/104-bits */
+		case SIOCSIWENCODE:
+			if (iwr->u.data.length > KEY_SIZE_WEP104)
+				return -EINVAL;
+			break;
+
 		default:
 			break;
 		}
-- 
1.5.4.3
---
