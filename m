Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753550AbeGFKmb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 06:42:31 -0400
Date: Fri, 6 Jul 2018 12:42:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 04/11] mt76x0: usb files
Message-ID: <20180706104226.GC2033@redhat.com> (sfid-20180706_124234_971314_31E3D325)
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
 <1530771142-4118-5-git-send-email-sgruszka@redhat.com>
 <20180705150519.GB17524@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180705150519.GB17524@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 05, 2018 at 05:05:20PM +0200, Lorenzo Bianconi wrote:
> > +static int mt76x0_suspend(struct usb_interface *usb_intf, pm_message_t state)
> > +{
> > +	struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
> > +
> > +	mt76x0_cleanup(dev);
> 
> Is it necessary to deallocate rx queue here in case of a system suspend?
> 

It's not optimal, but allow to utilize initialization and cleanup
routines in resume/suspend.

Regards.
Stanislaw
