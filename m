Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFF6C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83DA320652
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:59:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83DA320652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbeJAPgT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 11:36:19 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:4571 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbeJAPgT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 11:36:19 -0400
X-IronPort-AV: E=Sophos;i="5.54,327,1534834800"; 
   d="scan'208";a="20791996"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Oct 2018 01:59:37 -0700
Received: from ajaysk-VirtualBox (10.10.76.4) by chn-sv-exch05.mchp-main.com
 (10.10.76.106) with Microsoft SMTP Server id 14.3.352.0; Mon, 1 Oct 2018
 01:59:36 -0700
Date:   Mon, 1 Oct 2018 14:29:29 +0530
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH v3 00/29] staging: wilc1000: avoid static variables and
 cleanup changes
Message-ID: <20181001142929.7fc422d0@ajaysk-VirtualBox>
In-Reply-To: <20181001074734.w766omhed4ri3zuy@mwanda>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
        <20181001074734.w766omhed4ri3zuy@mwanda>
Organization: Microchip Technology
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dan,

On Mon, 1 Oct 2018 10:47:34 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Tue, Sep 25, 2018 at 11:53:15AM +0530, Ajay Singh wrote:
> > This patch series contains changes to avoid the use of static
> > variables. Cleanup changes to fix some checkpatch issues and return
> > void for function if their return value is not used.
> > Also deleted 'wilc_debugfs.c' file as it's not used.
> > 
> > Changes since v2:
> >    Included Joe's suggestion for patch#28
> >     - replaced previous patch with an improved version(refactor
> > code)
> > 
> > Changes since v1:
> >    Address Dan's comment for patch#29
> >     - return the correct error for failure in the second iteration  
> 
> Btw, I hate re-reviewing patches and I know everyone hates sending
> them. If someone complains about a 28/29 or a 29/29, then you can
> just ask Greg to apply the first 27 and redo the others in a follow
> on patchset.
> 
Sure, I will keep this point in mind while sending the series updates.

Regards
Ajay

