Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50625 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752733AbXJZIGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 04:06:01 -0400
Message-ID: <47219FE6.70900@sgi.com> (sfid-20071026_090617_825749_068086CD)
Date: Fri, 26 Oct 2007 10:05:58 +0200
From: Jes Sorensen <jes@sgi.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: iwl4965 detection problem
References: <47209C0C.5010505@sgi.com>	 <1193319925.5542.8.camel@localhost.localdomain>  <4720A509.2070708@sgi.com> <1193333545.2111.8.camel@localhost.localdomain>
In-Reply-To: <1193333545.2111.8.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> I've had this same problem with one machine and there were problems with
> those two files.  I fixed it on that machine (and was fixed on a few
> others using this procedure) by removing those two files and rebooting.
> 
> The symptom is that the driver loads and recognizes the card, but no
> wireless devices show up to userspace (via iwconfig, ifconfig, or
> in /sys/class/net) because device renames by udev and/or init scripts
> stomped over them (like trying to rename wmaster0 -> eth1 and then
> renaming wlan0 -> eth1 but failing because it was already taken).
> 
> Try killing those two files, making sure you're up to date, then
> restarting.

Hi Dan,

I tried that, but no go :-( Even before the card was detected by Fedora,
when I manually loaded the iwl4965 module, nothing showed up in
ifconfig -a, I had to unload/reload for anything to happen.

Cheers,
Jes

