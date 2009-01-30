Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:41394 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZA3N7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 08:59:51 -0500
Message-ID: <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk> (sfid-20090130_145956_019048_BD7C2C97)
In-Reply-To: <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
Date: Fri, 30 Jan 2009 13:59:46 -0000 (UTC)
Subject: Re: rtl8187 wireless issues
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Have compiled and install the latest driver and success!

Just to answer your questions ...

dmesg didnt offer much information other than "link is not ready"

Should have explained the detail of "cannot ping". Essentially I take t=
he
network down doing /etc/init.d/network stop. Change around which
ifcfg-interfaces start on boot then do /etc/init.d/network start. Thus,
the default route was always the active interface.

Do not use NetworkManager and use static ip addresses.

Anyway, hopefully everything is working.

Thanks for the response. Let me know if you require any more info or wo=
uld
like some testing done.

Regards

P.G. Richardson

PS. A minor thing which is probably my fault. I compiled the driver usi=
ng
make then ran make install. The latter installed the new mac82011, ifcf=
g
and b44 drivers. None of the other specific wireless drivers were copie=
d
to the kernel update directory. I had to copy the rtl8187 there manuall=
y.


> On Thu, Jan 29, 2009 at 12:46 PM, P.G. Richardson
> <p.g.richardson@phantomjinx.co.uk> wrote:
>> id: 0x8189 chipset: rtl8187b
>
> That's an older rtl8187b - there is no point trying mainline kernels,
> as the interesting development are happening
> in wireless-testing and takes a few months to get to mainline. i.e.
> trying 2.6.29 won't help. Can you download the current compat-wireles=
s
> tar ball (http://linuxwireless.org/en/users/Download) and give it a
> try?
>
> Also can you show your "dmesg | grep rtl" result ?
>
> The "can't ping" , etc behavior with multiple network interfaces is
> normal and quite simple to work around - you need to read up on
> "default route" and the "route" command.
>
> Are you using NetworkManager or configuring by hand? If you are not
> using NetworkManager, you need to set up dhcp manually. On 2nd
> thought, I am suprised you have problem with ping, because if you are
> using NetworkManager it should switch the default route, etc if you
> choose to switch to the wired interface.
>
> (You have come to the right place - Larry and Herton and I are the
> current maintainers of the rtl8187 driver).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
