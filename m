Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yorgi.telenet-ops.be ([195.130.133.69]:36795 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbYGWH66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 03:58:58 -0400
Message-ID: <4886E49D.6010700@tvcablenet.be> (sfid-20080723_095902_903838_201CA5CA)
Date: Wed, 23 Jul 2008 09:58:21 +0200
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: Re: [Bugme-new] [Bug 11144] New: dhcp doesn't work with iwl4965
References: <bug-11144-10286@http.bugzilla.kernel.org/> <20080722034850.dbbc5566.akpm@linux-foundation.org>
In-Reply-To: <20080722034850.dbbc5566.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Morton a =E9crit :
> (switched to email.  Please respond via emailed reply-to-all, not via=
 the
> bugzilla web interface).
>
> On Tue, 22 Jul 2008 03:21:33 -0700 (PDT) bugme-daemon@bugzilla.kernel=
=2Eorg wrote:
>
>  =20
>> http://bugzilla.kernel.org/show_bug.cgi?id=3D11144
>>
>>            Summary: dhcp doesn't work with iwl4965
>>            Product: Networking
>>            Version: 2.5
>>      KernelVersion: 2.6.26-git7
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: Wireless
>>         AssignedTo: networking_wireless@kernel-bugs.osdl.org
>>         ReportedBy: francois.valenduc@tvcablenet.be
>>
>>
>> Latest working kernel version: 2.6.26-git6
>> Earliest failing kernel version: 2.6.26-git7
>>    =20
>
> A very fresh regression.
>
>  =20
>> Distribution: Gentoo
>> Hardware Environment: Packard Bell MB86, iwl4965
>> Software Environment: dhcpcd
>> Problem Description:=20
>> I can't get an IP address via DHCP with my wireless connection. I ha=
ve an Intel
>> Wireless 4965 card and I use WPA personal with AES encryption. After=
 a
>> git-bisect run, it seems the first bad commit is the following:
>>
>> commit 175f9c1bba9b825d22b142d183c9e175488b260c
>> Author: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>> Date:   Sun Jul 20 00:08:47 2008 -0700
>>
>>     net_sched: Add size table for qdiscs
>>
>>     Add size table functions for qdiscs and calculate packet size in
>>     qdisc_enqueue().
>>
>>     Based on patch by Patrick McHardy
>>      http://marc.info/?l=3Dlinux-netdev&m=3D115201979221729&w=3D2
>>
>>
>>    =20
>
> A whole pile of networking patches went into mainline about 12 hours
> ago, one of which might have fixed this.  Can you please test
> 2.6.26-git10 once it has appeared and let us know the result?
>
>
> Thanks.
>
>
>  =20

The problem still occurs with 2.6.26-git-10. But if I use a static=20
address instead of DHCP, the connection work. DHCP also work with my=20
ethernet card (a Marvell yukon which use the sky2 driver). But DHCP=20
doesn't work with my wireless connection using the iwl4965 driver. As I=
=20
said, my router offer several time a correct IP adress but it is not=20
accepted by my computer. I don't use traffic shaping (see my iptables=20
rules). Furthermore, the problem still occurs if I disable iptables.
Does anybody have an idea to solve the problem ?

Thanks for your help,
=46ran=E7ois

P.S: why don't you want to use the bugzilla interface ?
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
