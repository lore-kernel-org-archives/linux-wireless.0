Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:50855 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab3J1PoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 11:44:21 -0400
Received: by mail-lb0-f169.google.com with SMTP id o14so3066932lbi.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 08:44:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526E33C3.60302@rempel-privat.de>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
	<CAMP44s0ypeV5JeoF=KWPM-VqZbyR_joJ-4Xg5icKqp2QiNN=Tw@mail.gmail.com>
	<526E33C3.60302@rempel-privat.de>
Date: Mon, 28 Oct 2013 09:44:18 -0600
Message-ID: <CAMP44s05-NRskvWHNqzVxTRiB_2DeRsPwQGAZZ3saM-VC=ZyQA@mail.gmail.com> (sfid-20131028_164424_484879_8AD3EC9D)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 3:52 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 28.10.2013 10:38, schrieb Felipe Contreras:
>> On Mon, Oct 28, 2013 at 2:31 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:

>>> Heh... this logs look like miracle :)
>>> My first assumption would be buggy router. There is no answer in
>>> wpa_supplicant log.
>>
>> Yeah, I bet the router is buggy, which router isn't? But why Windows 7
>> connects fine?
>
> May be it includes some workaround?

> You do not need to fight with devs, i think they are agree that some
> thing is wrong. But believe me, there are so many access points, which
> make problems or wear things. If you have a bug, does not mean other
> user have it.

I understand the problems of making wireless drivers work on different
kinds of access points, and I'm not fighting with devs, I'm just
saying that if it works in all other devices the problem is most
likely on this one.

And BTW, the devices we are talking about are very varied: Wii U,
Windows 7, Windows 8.1, Nokia N9, Android phone, iPhone, iMac, Amazon
Kindle. Yet the only device that seems to have a problem is my Linux
machine, I think it's pretty clear where the problem is.

And sure, it does not necessarily means that other people have the
same problem, but it is very unlikely that I'm the only one.

> Beside, how many clients use this AP?

Probably around a dozen.

> How big is the distance?

Probably around 10m.

> What do you configure in AdHock mode?

Nothing, I don't think it even works, but it associates. I just add mode=1.

network={
ssid="AXTEL-XXX"
proto=WPA2
scan_ssid=1
key_mgmt=WPA-PSK
psk="XXX"
mode=1
}

>>> Take wireshark and capture working and not working associational request.
>>
>> I'll try that. If only it was that easy to get a working association.
>
> Compare it with windows.

Right, I forgot I can use wireshark in Windows.

> and please read this, it will help to provide more information.
> http://wireless.kernel.org/en/users/Documentation/Reporting_bugs

I don't understand what exactly do you need from that list. I'm using
3.11.6, but as I said in the original report, the kernel version makes
no difference, even as far back as 3.6.0. I've put the dmesg log in
the original mail and there's nothing of value there. I could try
running with CONFIG_MAC80211_*_DEBUG stuff enabled, but do you really
think that will help?

If you really must know, this is exactly what I'm running:

config=$(mktemp)
pid="/run/wpa_supplicant_wlan0.pid"

cat > $config <<-EOF
country=MX
ap_scan=1
eapol_version=2
device_name=Nysa
device_type=1-0050F204-1

network={
ssid="AXTEL-7111"
proto=WPA2
scan_ssid=1
key_mgmt=WPA-PSK
psk="C3657111"
mode=0
}
EOF

wpa_supplicant -B -t -d -P $pid -i wlan0 -D nl80211,wext -c $config -f
/tmp/wpa.log

rm -f "$config"

I tried with wext, but that doesn't work at all. A curious fact is
that I need to enable CONFIG_CFG80211_WEXT=y for AP scanning to work,
even though I'm not using the wext driver.

I will try to get the wireshark logs.

-- 
Felipe Contreras
