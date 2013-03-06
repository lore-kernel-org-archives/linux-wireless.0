Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50938 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CFWD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 17:03:28 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r26M3OcL004879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 6 Mar 2013 14:03:25 -0800
Message-ID: <5137BD2C.5010208@candelatech.com> (sfid-20130306_230334_510297_40E90087)
Date: Wed, 06 Mar 2013 14:03:24 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Asymmetric ath9k upload v/s download throughput, sometimes.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While trying to get a reliable system to do throughput testing, I
hit something interesting.  I have two systems, same hardware, one
running AP the other STA.  They are cabled through attenuator, which is
set to 25dB of attenuation in this case.

Most of the time, I can run one-way UDP traffic at about 330Mbps either
upload or download direction.

But, sometimes, the AP can only transmit at about 220Mbps while the STA can
still upload at 330Mbps or so.

I just hit this problem, and while mucking around with it, I started/stopped
all processes on the two NICs (hostapd, wpa_supplicant), causing NICs to
go idle and back up...  And what do you know..that 'fixed' it.

Kernel is slightly patched 3.9-rc1+ from 2 days ago, but I've seen similar
issues on 3.7 and earlier kernels for some time now.

I am curious if there are any suggestions for what might could cause this
sort of behaviour.  I've looked through various debugfs files and so forth,
and cannot find any obvious reason for the observed behaviour.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

