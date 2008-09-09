Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:18526 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYIIShd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 14:37:33 -0400
Received: by ug-out-1314.google.com with SMTP id k3so249497ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2008 11:37:31 -0700 (PDT)
Message-ID: <48C6C262.7010803@gmail.com> (sfid-20080909_203739_382445_B5AE011A)
Date: Tue, 09 Sep 2008 19:37:22 +0100
MIME-Version: 1.0
To: jt@hpl.hp.com
CC: Pavel Roskin <proski@gnu.org>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere
 fw
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com> <1217672073-7094-2-git-send-email-kilroyd@gmail.com> <1217825304.10989.20.camel@dv> <1217864060.3139.10.camel@localhost.localdomain> <20080805162238.GA6294@bougret.hpl.hp.com> <20080902230621.GA28885@bougret.hpl.hp.com> <1220878110.2369.3.camel@dv> <20080908183203.GA7090@bougret.hpl.hp.com>
In-Reply-To: <20080908183203.GA7090@bougret.hpl.hp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jean Tourrilhes wrote:
> On Mon, Sep 08, 2008 at 08:48:30AM -0400, Pavel Roskin wrote:
>> No, it's still not fixed on x86_64.  scanflags in print_scanning_info()
>> in iwlist.c is 2, but srq->flags is 0 in orinoco_ioctl_setscan() in
>> orinoco.c.
>>
>> On i386,  srq->flags is 2 as expected and the scan results are correctly
>> influenced by the ESSID.
> 
> 	Try the attached patch.
> 
>  static int orinoco_ioctl_setscan(struct net_device *dev,
>  				 struct iw_request_info *info,
> -				 struct iw_param *srq,
> +				 struct iw_point *srq,
>  				 char *extra)

Thanks for finding that Jean! I've double checked, and agree it's the right fix.

FWIW, I've verified this compiles and (still) works as expected on my 32 bit system.



Dave.
