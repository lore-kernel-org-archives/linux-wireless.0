Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:41716 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaJHORM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 10:17:12 -0400
Received: by mail-vc0-f172.google.com with SMTP id lf12so6858426vcb.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2014 07:17:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <etPan.5433ced3.74b0dc51.2d48@Mac-Pro.local>
References: <etPan.5433ced3.74b0dc51.2d48@Mac-Pro.local>
Date: Wed, 8 Oct 2014 16:17:11 +0200
Message-ID: <CA+BoTQkvUkdkWDLOzu2cz6C6SGWFL2SCgwMDLf=ruaFwP9umjg@mail.gmail.com> (sfid-20141008_161715_952452_1EF25DB9)
Subject: Re: How to know the information about RTS reception in mac80211 or
 device driver
From: Michal Kazior <michal.kazior@tieto.com>
To: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ath10k@lists.infradead.org

On 7 October 2014 13:30, Okhwan Lee <ohlee@mwnl.snu.ac.kr> wrote:
> Hi,
>
> We are trying to develop an algorithm by using the information of RTS reception at the receiver side. (actually, we need the preceding frame of A-MPDU).
> As far as we know, RTS/CTS exchange is done by firmware of NIC.
> However, in monitor mode, we quite sure that the RTS/CTS frame reception should be reported to upper layer.
> As an evidence, Wireshark can capture and display the RTS/CTS reception.
>
> However, mac80211 and device driver (e.g., ath10k) can not recognize the reception of RTS even if we put the WiFi NIC in monitor mode.
> We check the type and subtype of frame_control field for all the received frames at the “ieee80211_rx_monitor” function of mac80211.
> We can find the reception of data frames amd mgmt frames, but there is no RTS/CTS frame.
> (We confirm that there is the RTS/CTS frame by using wireshark.)
>
> Is there any way to know the information about RTS reception in mac80211 or device driver?

I think you've just found an ath10k bug.

I've been running through Rx code lately. I was looking at
htt_rx_mpdu_status and noticed it was a bit greedy. I then recalled
someone was complaining about RTS reception.

I'll try to fix this soon. I'll put you in Cc in case you'd want to
play with it before it's merged.


Michał
