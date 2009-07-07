Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759238AbZGGQcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 12:32:43 -0400
Subject: Re: a question about marvell sd8686's wmm_config_change event
From: Dan Williams <dcbw@redhat.com>
To: fengzeheng <zehengfeng@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <5135d20a0907070928o19322c3waf41a7b59d4b309e@mail.gmail.com>
References: <5135d20a0907070928o19322c3waf41a7b59d4b309e@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 12:32:49 -0400
Message-Id: <1246984369.28570.42.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-08 at 00:28 +0800, fengzeheng wrote:
> hi, dan and all
>      My wireless card sd8686 reports that wmm_config_change about
> every 2 seconds though wmm's setting in AP's beacons don't change.
> seems that driver receive MACREG_INT_CODE_WMM_STATUS_CHANGE event from
> firmware every 2 seconds. And according
> to firmware spec v5.1  this event generated when firmware monitors a
> change in wmm state. This is a result of an ap change in the wmm
> parameter ie or a change in the operational state of one of the AC
> queues. However ,  I can't find any change of AP's wme settings in
> beacon from the sniffer packets. So why does firmware send this event?
> thanks for your any comments.

It's probably something in the internal firmware's WMM queues then, not
something from the AP's IEs.  Is the event causing a problem?

Dan


