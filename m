Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48742 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934979AbcKONUT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 08:20:19 -0500
Message-ID: <1479216012.12007.27.camel@sipsolutions.net> (sfid-20161115_142119_855402_D5E6B018)
Subject: Re: [PATCH V2] mac80211: Ignore VHT IE from peer with wrong
 rx_mcs_map
From: Johannes Berg <johannes@sipsolutions.net>
To: Filip Matusiak <filip.matusiak@tieto.com>,
        linux-wireless@vger.kernel.org
Cc: marek.kwaczynski@tieto.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 15 Nov 2016 14:20:12 +0100
In-Reply-To: <1478077466-4308-1-git-send-email-filip.matusiak@tieto.com> (sfid-20161102_100438_908657_9F74D2B9)
References: <1478077466-4308-1-git-send-email-filip.matusiak@tieto.com>
         (sfid-20161102_100438_908657_9F74D2B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-11-02 at 10:04 +0100, Filip Matusiak wrote:
> This is a workaround for VHT-enabled STAs which break the spec
> and have the VHT-MCS Rx map filled in with value 3 for all eight
> spacial streams, an example is AR9462 in AP mode.
> 
> As per spec, in section 22.1.1 Introduction to the VHT PHY
> A VHT STA shall support at least single spactial stream VHT-MCSs
> 0 to 7 (transmit and receive) in all supported channel widths.
> 
> Some devices in STA mode will get firmware assert when trying to
> associate, examples are QCA9377 & QCA6174.
> 
> Packet example of broken VHT Cap IE of AR9462:
> 
> [...]

Applied, thanks.

johannes
