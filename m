Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53747 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab3AYRxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 12:53:35 -0500
Received: by mail-wi0-f179.google.com with SMTP id o1so534368wic.12
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 09:53:34 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Improve TX status handling for BlockAckReq frames
Date: Fri, 25 Jan 2013 18:53:23 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ivdoorn@gmail.com" <ivdoorn@gmail.com>,
	"stf_xl@wp.pl" <stf_xl@wp.pl>,
	"andihartmann@01019freenet.de" <andihartmann@01019freenet.de>,
	Stanislaw Gruszka <sgruszka@redhat.com>
References: <1358440472-26678-1-git-send-email-helmut.schaa@googlemail.com> <201301171816.15309.chunkeey@googlemail.com> <13A1CEB6-9E61-4F02-A273-5F45F40A5D2C@gmail.com>
In-Reply-To: <13A1CEB6-9E61-4F02-A273-5F45F40A5D2C@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301251853.24699.chunkeey@googlemail.com> (sfid-20130125_185339_623854_6358484E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 17 January 2013 19:42:52 Gertjan van Wingerde wrote:
> On 17 jan. 2013, at 18:16, Christian Lamparter <chunkeey@googlemail.com> wrote:
> > On Thursday, January 17, 2013 05:34:32 PM Helmut Schaa wrote:
> >> Since rt2800 hardware isn't capable of reporting the TX status of
> >> BlockAckReq frames implement the TX status handling of BARs in
> >> rt2x00lib. We keep track of all BARs that are send out and try to
> >> match incoming BAs to the appropriate BARs. This allows us to report a
> >> more or less accurate TX status for BAR frames which in turn improves
> >> BA session stability.
> > ---
> > What about:
> >> commit 5b632fe85ec82e5c43740b52e74c66df50a37db3
> >> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> >> Date:   Mon Dec 3 12:56:33 2012 +0100
> >> mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
> > 
> > Should it be kept or dropped (as no driver uses it anymore?)
> 
> I guess it should be dropped. I guess we could create a revert patch for that once
> this patch has been merged.
Looks like the rt2x00 patch has been accepted :)
John, do you still want to remove the workaround, or
can we keep it?

Regards,
	Chr
