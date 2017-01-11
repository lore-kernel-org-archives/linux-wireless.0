Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:34870 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdAKJiW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 04:38:22 -0500
Received: by mail-pg0-f44.google.com with SMTP id 194so19485032pgd.2
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2017 01:38:22 -0800 (PST)
Subject: Re: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Cedric.Izoard@ceva-dsp.com
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
 <1484121737.23671.0.camel@sipsolutions.net>
 <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com>
 <1484125220.23671.1.camel@sipsolutions.net>
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <12d8a797-6c51-4a79-2820-1f9e2e72b2f5@gmail.com> (sfid-20170111_103826_350940_60860753)
Date: Wed, 11 Jan 2017 18:38:16 +0900
MIME-Version: 1.0
In-Reply-To: <1484125220.23671.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017年01月11日 18:00, Johannes Berg wrote:
> Ok, that's strange, but maybe there's a reason.
>
> Can you extract *any* information whatsoever? Like maybe if you switch
> to a VT console before running into the crash? I don't have any
> hardware to run this on, and hwsim doesn't have any issues.

I will call the mesh peers "STA A" and "STA B".

Both STA has one physical wireless I/F and wired I/F.
I have connected to both with SSH via wired I/F and started
wpa_supplicant with this command for both.
	sudo ./hostap/wpa_supplicant/wpa_supplicant -i <ifname> -D nl80211 -c 
mesh_sae.conf

STA A's mesh_sae.conf is this.

----------------------
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
user_mpm=1
update_config=0

network={
	ssid="mesh0"
	key_mgmt=SAE
	mode=5
	frequency=2412
	psk="01234567"
}
----------------------

STA B's mesh_sae.conf is this. The difference is "no_auto_peer=1".

----------------------
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
user_mpm=1
update_config=0

network={
	ssid="mesh0"
	key_mgmt=SAE
	mode=5
	frequency=2412
	psk="01234567"
	no_auto_peer=1
}
----------------------

Booting the wpa_supplicant finishes successfully.

After the successfull peering process, I could see
	MESH-PEER-CONNECTED
message on both side.

Then STA A or STA B crashes, not both.

Masashi Honma.
