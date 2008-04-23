Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:20118 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYDWWMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 18:12:34 -0400
Date: Wed, 23 Apr 2008 15:11:23 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: iwl4965 regression since 2.6.24
Message-ID: <20080423221123.GC17022@mail.oracle.com> (sfid-20080424_001312_529150_2D0A47D1)
References: <20080423124105.GA4783@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080423124105.GA4783@ics.muni.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 23, 2008 at 02:41:06PM +0200, Lukas Hejtmanek wrote:
> as of 2.6.25 kernel, the intel driver iwl4965 has serious troubles to
> associate with AP. I must many times set essid till the association is done.
> 
> Moreover, it seems that it is unable to associate with different AP (using the
> same SSID). I must remove the module completly to be able to associate to the
> different AP. I think it is big regression.

	I am experiencing the same problems on 2.6.24.  I have also
noticed that it cannot recover association after waking from sleep.  I
must set the essid before it will talk to the AP.  I always see this in
dmesg at the time:

  ADDRCONF(NETDEV_UP): wlan0: link is not ready

After I explicitly re-specify the ssid, I see this in dmesg:

  ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

	To clarify: when the interface comes up after boot or wake, it
associates but will not actually send data (Destination Host
Unreachable).  I must run "iwconfig wlan0 essid <ssid>".  After that, it
works.  When I move to a new network with a different access point, I
must unload and reload the module.
	Hopefully, I'll get a chance to run with debugging and send
along some logs.

Thinkpad x61s,
03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)


Joel

-- 

"One of the symptoms of an approaching nervous breakdown is the
 belief that one's work is terribly important."
         - Bertrand Russell 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
