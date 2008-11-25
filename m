Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n2b.bullet.mail.ac4.yahoo.com ([76.13.13.72]:30598 "HELO
	n2b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753196AbYKYCgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 21:36:54 -0500
Date: Mon, 24 Nov 2008 18:36:53 -0800 (PST)
From: Irwan Siajadi <dev.bahamot@yahoo.com>
Subject: Re: ath5k: can't browse at all.
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227552792.26229.6.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <334331.29428.qm@web59608.mail.ac4.yahoo.com> (sfid-20081125_033656_941240_20EAAA79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




--- On Mon, 11/24/08, Pavel Roskin <proski@gnu.org> wrote:

> From: Pavel Roskin <proski@gnu.org>
> Subject: Re: ath5k: can't browse at all.
> To: "Irwan Siajadi" <dev.bahamot@yahoo.com>
> Cc: linux-wireless@vger.kernel.org
> Date: Monday, November 24, 2008, 6:53 PM
> On Mon, 2008-11-24 at 09:41 -0800, Irwan Siajadi wrote:
> > The AR2425 is able to obtain IP address from the
> router, 
> > able to ping with good results, but can't browse
> at all.
> > Below are the info on my setup, if you need more info
> please let me know.
> 
> That's unlikely to be a driver problem.  The driver
> doesn't distinguish
> pings from other packets.  The only significant difference
> could be in
> the packet size.  You can try ping with larger packets to
> check if
> that's the problem.

Ping with large packet size doesn't seem to be a problem.
[root@localhost staff]# ping 192.168.1.254 -s 1500
PING 192.168.1.254 (192.168.1.254) 1500(1528) bytes of data.
1508 bytes from 192.168.1.254: icmp_seq=1 ttl=128 time=2.75 ms
1508 bytes from 192.168.1.254: icmp_seq=2 ttl=128 time=2.61 ms
...
1508 bytes from 192.168.1.254: icmp_seq=13 ttl=128 time=2.69 ms
1508 bytes from 192.168.1.254: icmp_seq=14 ttl=128 time=2.72 ms
^C
--- 192.168.1.254 ping statistics ---
14 packets transmitted, 14 received, 0% packet loss, time 13574ms
rtt min/avg/max/mdev = 2.586/2.692/2.781/0.091 ms


> 
> I suggest that you use normal network troubleshooting
> procedures and not
> assume the driver to be a problem unless you have a better
> evidence.
> Check routing, check if the nameservers in /etc/resolv.conf
> are working.
> I'm sure there are detailed guides how to troubleshoot
> networks.

I believe the problem is in the driver because I can browse normally as soon as I change the driver to ndiswrapper. Tracepath shows there's nothing wrong with routing or nameservers.


> 
> -- 
> Regards,
> Pavel Roskin


      

