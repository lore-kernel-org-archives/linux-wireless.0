Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64168 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2BTJsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 04:48:07 -0500
Received: by bkcjm19 with SMTP id jm19so4382963bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2012 01:48:06 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Yingang Fu <yingang.fu@gmail.com>
Subject: Re: AP send null-data packet?
Date: Mon, 20 Feb 2012 10:48:01 +0100
Cc: linux-wireless@vger.kernel.org
References: <CAHPDcRtEHP7LAGPDE_UDs-P9Nq_ZrQbxsMYDCt-eXvjR+5=6kQ@mail.gmail.com>
In-Reply-To: <CAHPDcRtEHP7LAGPDE_UDs-P9Nq_ZrQbxsMYDCt-eXvjR+5=6kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201202201048.01883.chunkeey@googlemail.com> (sfid-20120220_104814_747407_4D8B618A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 20, 2012 08:12:34 AM Yingang Fu wrote:
> It is wired that my AP send the station a null-date packet.
> As i know that this packet could only been sent by the station.
> Under which case the AP will send out this type of packet?

Don't know much about other AP software. But hostapd sends them
to check if a station is still in range and active.

quote from hostapd.conf:

# Station inactivity limit
#
# If a station does not send anything in ap_max_inactivity seconds, an
# empty data frame is sent to it in order to verify whether it is
# still in range. If this frame is not ACKed, the station will be
# disassociated and then deauthenticated. This feature is used to
# clear station table of old entries when the STAs move out of the
# range.  

Regards,
	Chr
