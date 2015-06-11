Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36709 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbbFKGy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 02:54:26 -0400
Received: by wigg3 with SMTP id g3so66593755wig.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 23:54:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55789EBF.2060501@candelatech.com>
References: <55789EBF.2060501@candelatech.com>
Date: Thu, 11 Jun 2015 08:54:25 +0200
Message-ID: <CA+BoTQmWmrkCjTkq9R9qXZBqq=ynNKdsgn4uLNAucetXy39GRQ@mail.gmail.com> (sfid-20150611_085430_396141_051F3666)
Subject: Re: Anyone tried ath10k AP with 40Mhz operation?
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 June 2015 at 22:31, Ben Greear <greearb@candelatech.com> wrote:
> I'm trying this hostapd config file.  Beacons seem OK, and station
> associates.  Station puts DHCP Discover on the air (using 20Mhz according
> to wireshark).  AP reads this, and thinks it is sending a DHCP response back,
> but sniffer never shows DHCP response on the air.

Is the MSDU carrying DHCP resp completed with "ok" status? Or is it
maybe no-ack or discarded?


> Kernel is 4.0.4+, ath10k firmware is CT firmware, 10.1.467 based.
>
> I am curious if anyone else has tried to do this?
>
> Thanks,
> Ben
>
> interface=vap50
> driver=nl80211
> logger_syslog=-1
> logger_syslog_level=2
> logger_stdout=-1
> logger_stdout_level=2
> ctrl_interface=/var/run/hostapd
> ctrl_interface_group=0
> ssid=ben-ota-2a
[...]

Works for me on c7b39fdeb479a7956a3c41638d527196ce295fdd
(github.com/kvalo/ath) with
 AP: qca988x hw2.0, 10.1.467.2-1
 STA: qca6174 hw2.2 (its a 2x2),

I test by using ip6 ping on each possible endpoint pair (ap->sta,
sta->ap). I flush arp/neigh tables on all endpoints before each ping
so both multicast and unicast is tested.

Within the same quick-n-dirty OTA env I get the following UDP (iperf -P5):

 HT40 (ieee80211ac=0):
  qca6174 -> qca988x  228.383 mbps
  qca988x -> qca6174  238.528 mbps

 VHT40 (your config):
  qca6174 -> qca988x  234.64  mbps
  qca988x -> qca6174  298.723 mbps

 VHT80 (vht_oper_centr_freq_seg0_idx=44, vht_oper_chwidth=1)
  qca6174 -> qca988x  377.092 mbps
  qca988x -> qca6174  483.287 mbps


Michał
