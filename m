Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab3H0JP0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 05:15:26 -0400
Date: Tue, 27 Aug 2013 11:13:34 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Fabien ADAM <id2ndr@crocobox.org>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 3.11 v2] rt2800: fix wrong TX power
 compensation
Message-ID: <20130827091334.GC5548@redhat.com> (sfid-20130827_111534_162639_4EB9EC53)
References: <20130826131851.GB10525@redhat.com>
 <1377548398.4408.4.camel@mattotaupa>
 <20130827080001.GA2609@redhat.com>
 <20130827081340.GB2609@redhat.com>
 <1377591967.5019.25.camel@mattotaupa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377591967.5019.25.camel@mattotaupa>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 27, 2013 at 10:26:07AM +0200, Paul Menzel wrote:
> >  	/*
> > +	 * First check if temperature compensation is supported.
> > +	 */
> > +	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
> > +	if (!rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_TX_ALC))
> > +		return 0;
> 
> Could a (debug) message be printed that temperature compensations is not
> supported? Not sure if that should be done in the library or the code
> calling this function.

This is frequent path, so it will need to be a printk_once() based
message, but perhaps would be better to print chip capabilities
coded on the EEPROM together with "Chipset detected" message on
device initialization.

Anyway, we can add debugging on separate patch.

Stanislaw 

