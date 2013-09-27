Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 174-143-244-95.static.cloud-ips.com ([174.143.244.95]:58577
	"EHLO mail.catnarok.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3I0IZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 04:25:36 -0400
Date: Fri, 27 Sep 2013 08:02:39 +0000
From: Michael Stolovitzsky <emestee@catnarok.net>
To: linux-wireless@vger.kernel.org
Subject: Re: bcma 3.12-rc1 scheduling while atomic
Message-ID: <20130927080239.GA2492@mail.catnarok.net> (sfid-20130927_102539_847850_F42235BD)
References: <1380142945.23272.42.camel@dcbw.foobar.com>
 <5243E72A.4040108@broadcom.com>
 <5243ED7C.7070203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5243ED7C.7070203@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-09-26, Daniel Borkmann wrote:
> On 09/26/2013 09:50 AM, Arend van Spriel wrote:
> >On 09/25/2013 11:02 PM, Dan Williams wrote:
> >>static int brcms_ops_start(struct ieee80211_hw *hw)
> >>{
> >>    ...
> >>         spin_lock_bh(&wl->lock);
> >>    ...
> >>                         err = brcms_up(wl);
> >>                         <eventually calls usleep() from bcma_pcie_mdio_set_phy()>
> >>    ...
> >>         spin_unlock_bh(&wl->lock);
> >>    ...
> >>}
> >
> >Hi Dan,
> >
> >I submitted two patches to John yesterday to address this.
> >
> >http://mid.gmane.org/1380103864-10447-3-git-send-email-arend@broadcom.com
> >http://mid.gmane.org/1380103864-10447-4-git-send-email-arend@broadcom.com
> 
> >>[    7.607842] BUG: scheduling while atomic: NetworkManager/523/0x00000200

Hi,

Just wanted to confirm that this removed the problem for me in 3.12.0-rc2. 
Thanks again!.
