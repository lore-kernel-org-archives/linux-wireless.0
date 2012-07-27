Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm19.bullet.mail.ird.yahoo.com ([77.238.189.76]:22812 "HELO
	nm19.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751049Ab2G0Gex convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 02:34:53 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net>
Message-ID: <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> (sfid-20120727_083524_890707_CD71AD36)
Date: Fri, 27 Jul 2012 07:34:52 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <5011BC0A.8060600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

I am using hostapd v0.7.3 but I did not install the bleeding-edge compat-wireless drivers.

What I noticed is that your script refers to module se while I have a ce. (I am not sure if this can impact or explain the differences between your setup and mine).

When I download the drivers from http://wireless.kernel.org/en/users/Download#Where_to_download_bleeding_edge, I got this file "compat-wireless-2.6.tar.bz2" which contains maybe a too old version compat-wireless-2012-05-10.

Should I install this version?
If I install kernel 3.5.0, will I still need to install the compat-wireless drivers?

Thanks
XabiX


> I finally finished the bug bisection that I was doing and set up an RTL8188CE 
> with my script on wireless-testing 3.5.0, which is the same wireless code as you 
> 
> will get with the bleeding-edge compat-wireless. BTW, that is the wireless code 
> that will be in 3.6.0 in about 3 months. When I started my script, I got the 
> following:
> 
> finger@larrylap:~> sudo ./control_ap start wlan0 eth0
> Starting AP mode for wlan0 at address 192.168.0.1
> iptables: No chain/target/match by that name.
> Internet Systems Consortium DHCP Server 4.2.3-P2
> Copyright 2004-2012 Internet Systems Consortium.
> All rights reserved.
> For info, please visit https://www.isc.org/software/dhcp/
> Not searching LDAP since ldap-server, ldap-port and ldap-base-dn were not 
> specified in the config file
> Wrote 1 leases to leases file.
> Listening on LPF/wlan0/1c:65:9d:15:c2:bd/192.168.0.0/24
> Sending on   LPF/wlan0/1c:65:9d:15:c2:bd/192.168.0.0/24
> Sending on   Socket/fallback/fallback-net
> Configuration file: /root/hostapd.conf
> finger@larrylap:~>
> 
> I was able to associate and authenticate with this new AP and connect through it 
> 
> to the Internet. Obviously this kernel does not have one of the iptables 
> modules, but otherwise all is well.
> 
> What version of hostapd are you using? Mine is 1.0.
> 
> You need to use compat-wireless and make certain that hostapd is new enough. I 
> think 0.7.3 would be OK.
> 
> Larry
> 
