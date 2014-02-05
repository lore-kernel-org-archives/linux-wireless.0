Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14409 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaBEIVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 03:21:35 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-pci@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to pci_disable_msi()
References: <cover.1389904166.git.agordeev@redhat.com>
	<ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
	<20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
	<87y51qohjn.fsf@kamboji.qca.qualcomm.com>
	<20140204190935.GA1430@dhcp-26-207.brq.redhat.com>
Date: Wed, 5 Feb 2014 10:21:28 +0200
In-Reply-To: <20140204190935.GA1430@dhcp-26-207.brq.redhat.com> (Alexander
	Gordeev's message of "Tue, 4 Feb 2014 20:09:36 +0100")
Message-ID: <8761oum0l3.fsf@kamboji.qca.qualcomm.com> (sfid-20140205_092153_471985_068AED48)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexander Gordeev <agordeev@redhat.com> writes:

> On Tue, Feb 04, 2014 at 08:32:12PM +0200, Kalle Valo wrote:
>> Alexander Gordeev <agordeev@redhat.com> writes:
>> 
>> I don't understand how this is superfluous. When I read the
>> documentation for pci_enable_msi_block() it states that if it can't
>> allocate all requests, it will return the number requests it could
>> allocate. And in that case we want to fall back other modes.
>> 
>> Am I missing something?
>
> Yep. The documentation states 'could have been allocated', not 'could
> allocate'. IOW, MSIs are *not* enabled if a positive value returned.
> The code I changed tries to disable MSIs in such case, although it is
> not necessary, nor required. Just superfluous.

Ah, thanks for explaining that. I added this to the commit log (I hate
empty commit logs anyway):

    ath10k: Get rid of superfluous call to pci_disable_msi()
    
    The documentation states that pci_enable_msi_block() returns the number of
    requests 'could have been allocated', not 'could allocate'. IOW, MSIs are *not*
    enabled if a positive value returned.
    
    kvalo: add commit log based on Alexander's email
    
    Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Is it ok for me to take these patches to my ath.git tree or would you
prefer to route them some other way?

-- 
Kalle Valo
