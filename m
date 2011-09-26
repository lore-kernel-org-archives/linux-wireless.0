Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36511 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1IZWol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 18:44:41 -0400
Received: by ywb5 with SMTP id 5so4743266ywb.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 15:44:40 -0700 (PDT)
Message-ID: <4E81005C.7010303@lwfinger.net> (sfid-20110927_004444_788176_122216B9)
Date: Mon, 26 Sep 2011 17:44:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Henrik Friedrichsen <hrkfdn@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM Fritz!Box
 (7390)" incompatible
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com> <1317050380.1958.13.camel@wwguy-huron> <CAJTrwG46qRYvda1vcCZXv0BTUyf26gx2qgpNgOG-bm-BCMpqfg@mail.gmail.com> <1317053131.1958.15.camel@wwguy-huron> <C5A7FB31FD9AEA42B600BDC3C74F8E0017052223@orsmsx511.amr.corp.intel.com> <CAJTrwG5AvbtNRZi54tzAoUDv5X9QLVY3L=-OgHYRtnJ-RMesrQ@mail.gmail.com> <1317062004.1958.18.camel@wwguy-huron> <CAJTrwG57r-B-eT-FODsDW1UgoVcS68zcUWo1mOrdHRdoXtNmCg@mail.gmail.com> <C5A7FB31FD9AEA42B600BDC3C74F8E001705253B@orsmsx511.amr.corp.intel.com> <CAJTrwG5MXfixhnNPOdoA3-DYEeKpC==uv4WvE78ZE5U+A10T7Q@mail.gmail.com> <1317071501.2400.10.camel@wwguy-ubuntu> <CAJTrwG6_ybjD9u2zMi+bY73j6CZoncbmOzk8N2N=8Cd=EWLUcA@mail.gmail.com> <1317071853.2400.11.camel@wwguy-ubuntu> <CAJTrwG5ydoheYzYuRZaaR0AfqBgE9KnfYQ8X_0esRNVog3hF=g@mail.gmail.com> <4E80F522.3010903@lwfinger.net> <CAJTrwG6r2ZEUg8VugVxDQ_AKL6_ukdregydm-_r9SjUMNbwBHQ@mail.gmail.com>
In-Reply-To: <CAJTrwG6r2ZEUg8VugVxDQ_AKL6_ukdregydm-_r9SjUMNbwBHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2011 05:12 PM, Henrik Friedrichsen wrote:
> On Mon, Sep 26, 2011 at 11:56 PM, Larry Finger
> <Larry.Finger@lwfinger.net>  wrote:
>> Of course, it should take a little over 4 sec. Try adding the -D switch to
>> the ping command. Does repeating the ping command immediately change the
>> timing?
>
> There you go:
> ~>  ping -Dc5 fritz.box
> PING fritz.box (192.168.178.1) 56(84) bytes of data.
> [1317074796.140468] 64 bytes from fritz.box (192.168.178.1):
> icmp_req=1 ttl=64 time=1.19 ms
> [1317074804.154425] 64 bytes from fritz.box (192.168.178.1):
> icmp_req=2 ttl=64 time=1.52 ms
> [1317074812.165947] 64 bytes from fritz.box (192.168.178.1):
> icmp_req=3 ttl=64 time=1.20 ms
> [1317074820.177252] 64 bytes from fritz.box (192.168.178.1):
> icmp_req=4 ttl=64 time=1.23 ms
> [1317074828.187470] 64 bytes from fritz.box (192.168.178.1):
> icmp_req=5 ttl=64 time=1.76 ms
>
> Nope, it doesn't.

Your ping seems to have an interval of 8 seconds, not 1 like the man page says.

Mine shows

finger@larrylap:~> ping -D -c5 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
[1317073193.249666] 64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=2.19 ms
[1317073194.251148] 64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=2.27 ms
[1317073195.250589] 64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=1.14 ms
[1317073196.252548] 64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=1.76 ms
[1317073197.253527] 64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=0.801 ms

What does 'ping -i1 -D -c5 <AP>' show?

Larry
