Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:60297 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab2KTWUD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 17:20:03 -0500
Date: Wed, 21 Nov 2012 02:04:22 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: FYI: "Failed to stop TX DMA!" not fixed in kernel 3.6.7
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D07C10F39@RockMX01.rock.corp>
Message-ID: <alpine.DEB.2.02.1211210202300.8668@icf.org.ru> (sfid-20121120_232010_505604_9B6C3FD9)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C10F39@RockMX01.rock.corp>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-1571371633-1353449062=:8668"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-1571371633-1353449062=:8668
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-11-19 19:33 -0000, Chaoxing Lin wrote linux-wireless@vger.kernel.or...:

Hi all, i can confim this, "Failed to stop TX DMA!" steel exists in 802.11s and other modes too,
i use many different cards but all ar9002 based.

CL>Just FYI
CL>
CL>Kernel 3.6.7 change log says "This patch might fix crashes and "Failed to stop TX DMA!" messages."
CL>
CL>I tried it on Dell laptop with ar9390 radio.
CL>Still, I got error message like below
CL>
CL>"ath: phy0: Failed to stop TX DMA, queues=0x005!"
CL>"ath: phy0: Failed to stop TX DMA, queues=0x001!"
CL>
CL>I am testing 802.11s mesh on 802.11a channel 40, no HT enabled.
CL>
CL>
CL>-----------------------------
CL>
CL>commit cd585fb70b89fb57f8dffb03a2a72c30f81f5da6
CL>Author: Felix Fietkau <nbd@openwrt.org>
CL>Date:   Fri Oct 26 00:31:11 2012 +0200
CL>
CL>    ath9k: fix stale pointers potentially causing access to free'd skbs
CL>    
CL>    commit 8c6e30936a7893a85f6222084f0f26aceb81137a upstream.
CL>    
CL>    bf->bf_next is only while buffers are chained as part of an A-MPDU
CL>    in the tx queue. When a tid queue is flushed (e.g. on tearing down
CL>    an aggregation session), frames can be enqueued again as normal
CL>    transmission, without bf_next being cleared. This can lead to the
CL>    old pointer being dereferenced again later.
CL>    
CL>    This patch might fix crashes and "Failed to stop TX DMA!" messages.
CL>    
CL>    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
CL>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
CL>    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CL>--
CL>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
CL>the body of a message to majordomo@vger.kernel.org
CL>More majordomo info at  http://vger.kernel.org/majordomo-info.html
CL>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-1571371633-1353449062=:8668--
