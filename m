Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59247 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbbALLyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 06:54:53 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so18794054wgh.2
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 03:54:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5492CFF5.9060107@open-mesh.com>
References: <5492CFF5.9060107@open-mesh.com>
Date: Mon, 12 Jan 2015 12:54:52 +0100
Message-ID: <CA+BoTQm1H9jAszUH_gQCjcEk-GCQG0r9r7Jb2VdpM1CQF7jXeg@mail.gmail.com> (sfid-20150112_125501_327665_F9F185F7)
Subject: Re: ath10k: fw_stats not reporting peer_stats with 10.2
From: Michal Kazior <michal.kazior@tieto.com>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 December 2014 at 14:00, Antonio Quartulli <antonio@open-mesh.com> wrote:
> Hello,

Hi,

Sorry for the late reply.


> (line grabbed from dmesg at boot time)
>
> On my device I have configured 2 AP vifs and for each of them I would
> like to read the last TX rate of the associated stations.
>
> As I've read on wireless.kernel.org this is not possible through the
> standard nl/cfg80211 interface and therefore I have been trying to read
> /sys/kernel/debug/ieee80211/phy1/ath10k/fw_stats  , but this file always
> reports "ath10k PEER stats (0)" (no peers..).
>
> I tried printing some debug messages here and there and the only useful
> information I got is that in "ath10k_wmi_10x_pull_fw_stats()" the value
> of "ev->num_peer_stats" is always 0.
>
> Is this yet another fw limitation?

Firmware stats has a very fragile ABI. Apparently 10.2 changed it
again and thus is broken. I'll try to look into it more if time
permits.


> I also realized that upon station connection ath10k receives the
> WMI_10_2_PEER_RATECODE_LIST_EVENTID event but it is not handled as no
> handler is implemented. Might it be related with my problem ?

No. That's not the problem.


Michał
