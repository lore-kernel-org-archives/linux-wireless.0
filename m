Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab0JZFvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 01:51:03 -0400
Subject: Re: [RFT] mac80211: fix null pointer dereference on
 ieee80211_stop_tx_ba_session()
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@google.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinqpj1O9Rpnk13JM-pFB_CkYfHeQvFpjQktQOD1@mail.gmail.com>
References: <1287803778-10330-1-git-send-email-lrodriguez@atheros.com>
	 <1287995012.3587.2.camel@jlt3.sipsolutions.net>
	 <AANLkTinqpj1O9Rpnk13JM-pFB_CkYfHeQvFpjQktQOD1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 07:50:58 +0200
Message-ID: <1288072258.3761.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[added list back]

On Mon, 2010-10-25 at 15:10 -0700, Sam Leffler wrote:

> It appears the null ptr deref is actually in
>  sta_addba_resp_timer_expired and there tid deref is protected only by
> the rcu lock and not the spin lock.  That is, I see a PC
> of ieee80211_stop_tx_ba_session+0xa4 and offset 0xa4 from that symbol
> gives me 4e66 in this assembler (objdump of mac80211.ko):
> 
> 
> 00004e47 <sta_addba_resp_timer_expired>:
>     4e47:       55                      push   %ebp
>     4e48:       89 e5                   mov    %esp,%ebp
>     4e4a:       e8 fc ff ff ff          call   4e4b
> <sta_addba_resp_timer_expired+0x4>
>     4e4f:       0f b6 10                movzbl (%eax),%edx
>     4e52:       29 d0                   sub    %edx,%eax
>     4e54:       2d a0 01 00 00          sub    $0x1a0,%eax
>     4e59:       8d 8c 90 4c 01 00 00    lea    0x14c(%eax,%edx,4),%ecx
>     4e60:       8b 09                   mov    (%ecx),%ecx
>     4e62:       85 c9                   test   %ecx,%ecx
>     4e64:       74 10                   je     4e76
> <sta_addba_resp_timer_expired+0x2f>
>     4e66:       f6 41 48 02             testb  $0x2,0x48(%ecx)
>     4e6a:       75 0a                   jne    4e76
> <sta_addba_resp_timer_expired+0x2f>
>     4e6c:       05 b8 01 00 00          add    $0x1b8,%eax
>     4e71:       e8 fc ff ff ff          call   4e72
> <sta_addba_resp_timer_expired+0x2b>
>     4e76:       5d                      pop    %ebp
>     4e77:       c3                      ret
> 
> 
> Is that right?  If so does this deref need to be protected by the spin
> lock?  I have no idea how these data structures protected--but I'm
> learning :)

Yes, that deref is right -- but do you have "mac80211: delete AddBA
response timer" in your tree?

johannes


