Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35092 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbGAIIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 04:08:35 -0400
Received: by pactm7 with SMTP id tm7so19296581pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2015 01:08:34 -0700 (PDT)
Date: Wed, 1 Jul 2015 13:38:27 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Michel von Czettritz <michel.von.czettritz@gmail.com>,
	devel@driverdev.osuosl.org, gregkh@linux.com,
	Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jes.Sorensen@redhat.com
Subject: Re: [PATCH 3/3] staging: rtl8723au: function no longer discards
 return value
Message-ID: <20150701080827.GE2411@sudip-PC> (sfid-20150701_100841_172981_0C542C0F)
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
 <f1f04f73db3d925d4a790a07fc56154ba98871fc.1435700714.git.michel.von.czettritz@gmail.com>
 <20150701071224.GC2411@sudip-PC>
 <20150701075042.GT28762@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150701075042.GT28762@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 01, 2015 at 10:50:42AM +0300, Dan Carpenter wrote:
> On Wed, Jul 01, 2015 at 12:42:24PM +0530, Sudip Mukherjee wrote:
> > On Tue, Jun 30, 2015 at 11:54:59PM +0200, Michel von Czettritz wrote:
> > > The return value of FillH2CCmd in rtl8723a_set_rssi_cmd and
> > > rtl8723a_set_raid_cmd is never checked. Both functions always return
> > > _SUCCESS.
> > > 
> > > Both functions now return the return value of FillH2CCmd.
> > If they are never checked then why do we need to return some value?
> > why not make them void?
> 
> They probably *should* be checked eventually?
yes, they should check the sucess/failure of the commands. If that plan
is there to check the values afterwards then the patch is correct.

regards
sudip
