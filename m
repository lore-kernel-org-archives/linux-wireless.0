Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40702 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1G2UvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 16:51:16 -0400
Received: by qwk3 with SMTP id 3so2019650qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 13:51:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL114-W54CACDD9B23D044E0916368A370@phx.gbl>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <COL114-W76260EA23039CA8000DB88A320@phx.gbl>
 <CAB=NE6Wcn3-GwqPJQDXOT0JCNnZgCs1E7HecWrXpc8LS+XRyDA@mail.gmail.com>
 <201107262031.11394.chunkeey@googlemail.com> <CAB=NE6WoGZfpGnNkdaLdtN+nC+aM1mxV4rkUCMarnuDonQeJeg@mail.gmail.com>
 <COL114-W2204F3FA55EF4C0D20D0C58A350@phx.gbl> <CAB=NE6WCagRUrMynd2CoAAN_LtoVkaoCYxOLE1COKx9zXgCBuQ@mail.gmail.com>
 <COL114-W50D316103F96D9ED1310098A340@phx.gbl> <COL114-W54CACDD9B23D044E0916368A370@phx.gbl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 29 Jul 2011 13:50:54 -0700
Message-ID: <CAB=NE6Xc_9DcCz2KfFwR8x2wK5uUt61cH-rP5rNA+-B8XK2gYQ@mail.gmail.com> (sfid-20110729_225119_875436_19A03EF5)
Subject: Re: problem on ACS
To: MingAnn Ng <devil_eddie01@hotmail.com>
Cc: nbd@openwrt.org, chunkeey@googlemail.com,
	wireless testing <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 12:39 AM, MingAnn Ng <devil_eddie01@hotmail.com> wrote:
> Survey 2 from wlan0:
>  noise:    -84 dBm
>  channel active time:  12 ms
>  channel busy time:  0 ms
>  channel receive time:  0 ms
>  channel transmit time:  0 ms
>  interference factor:  9223372036854775815.000000

This is caused by log2(0), this if fixed as follows:


diff --git a/src/ap/acs.c b/src/ap/acs.c
index aa5498e..04b1e31 100644
--- a/src/ap/acs.c
+++ b/src/ap/acs.c
@@ -125,7 +125,7 @@ static u64 min(u64 a, u64 b)
  */
 static u64 log2_sane(u64 val)
 {
-	return log2(min(1073741824, val));
+	return return (!val) ? 0 : log2(min(1073741824, val));
 }


I'll send a new version of the last patch with this fix, thanks for
reporting this.

  Luis
