Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFF4C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0E692084F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552392424;
	bh=15q0Lm4ubNeZVZ+YGa06hcl8kTas2cbPKWCbkluMaHc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=0JxyeYchNcMCXKUDDIFscRXA7mXkcj+rYGpqTP9pSYwilp/dcYAXnxsvvDiE0Sj1g
	 lLai9XKed71imcD9y/+pwx/iTWGVQi/tVimbJNwKrVkR9kSkCEpVoznBn71EgZ0aPR
	 dGF3zdpnP1mivS6rdV3SiGtkboJhRWItNrvaZ3ss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfCLMHD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 08:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbfCLMHC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 08:07:02 -0400
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFCF32084F
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 12:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552392422;
        bh=15q0Lm4ubNeZVZ+YGa06hcl8kTas2cbPKWCbkluMaHc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=s27nJS2c6dNcA7WZWC3gUTNp/F3eWtbSJR5Jdu/3ANjQicT/vaUxzlDVxTzSSebPd
         q5cL1V7Ag77yIH3I1v175AOS3xG//7E+nv6/W5F0ekShrVwXaaIlRnxbMlO1vAissa
         Pzl+zi4kEncczpeknt3RSEAJQpnYDsnbLRyywVbk=
Received: by mail-qt1-f181.google.com with SMTP id b3so2177940qtj.3
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 05:07:01 -0700 (PDT)
X-Gm-Message-State: APjAAAUmnU4B4I37gKUf8t7MP21KIN/61INdQoH6/81ZpLu1TygjfK85
        bdZB5QfNHvLDrSLqoeDlWX1AUz0Xs33frsJ9M7o=
X-Google-Smtp-Source: APXvYqxIuLYYf8XrmQFiL15M4tL74eBa98MHGZeyBmSnv0ahMKwCTNjjGynDElHLODG/eUNDeVZ76OkXBm1fwk5OWG8=
X-Received: by 2002:a0c:c96e:: with SMTP id v43mr30107786qvj.200.1552392420831;
 Tue, 12 Mar 2019 05:07:00 -0700 (PDT)
MIME-Version: 1.0
References: <CY4PR18MB123768713184F5801D645001A0750@CY4PR18MB1237.namprd18.prod.outlook.com>
In-Reply-To: <CY4PR18MB123768713184F5801D645001A0750@CY4PR18MB1237.namprd18.prod.outlook.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Tue, 12 Mar 2019 08:06:49 -0400
X-Gmail-Original-Message-ID: <CA+5PVA65FdUW+uintfGb3kwjhi9373uPSTaDO+OGR6D0EwPqww@mail.gmail.com>
Message-ID: <CA+5PVA65FdUW+uintfGb3kwjhi9373uPSTaDO+OGR6D0EwPqww@mail.gmail.com>
Subject: Re: pull-request mwifiex-firmware 2019-02-28
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        James Cao <jcao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Mayur Arakere <mayur@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 28, 2019 at 1:10 PM Ganapathi Bhat <gbhat@marvell.com> wrote:
>
> The following changes since commit bd72387b8e49b1b7268ee60c97a131419284fb39:
>
>   linux-firmware: update Marvell PCIe-USB8997 firmware image (2019-02-12 11:42:24 +0530)
>
> are available in the git repository at:
>
>   git://git.marvell.com/mwifiex-firmware.git
>
> for you to fetch changes up to 78d2b16af093783d40f0b8990d5d9ede8c3281d3:
>
>   linux-firmware: update Marvell 8787/8801/8887 firmware images (2019-02-28 23:35:32 +0530)
>
> ----------------------------------------------------------------
> Ganapathi Bhat (2):
>       linux-firmware: update Marvell 8897/8997 firmware images
>       linux-firmware: update Marvell 8787/8801/8887 firmware images
>
>  WHENCE                       |  12 ++++++------
>  mrvl/pcie8897_uapsta.bin     | Bin 843828 -> 723540 bytes
>  mrvl/pcie8997_wlan_v4.bin    | Bin 428788 -> 456488 bytes
>  mrvl/sd8787_uapsta.bin       | Bin 463240 -> 466592 bytes
>  mrvl/sd8801_uapsta.bin       | Bin 258680 -> 255988 bytes
>  mrvl/sd8887_uapsta.bin       | Bin 695532 -> 616840 bytes
>  mrvl/usbusb8997_combo_v4.bin | Bin 604536 -> 610252 bytes
>  7 files changed, 6 insertions(+), 6 deletions(-)

Pulled and pushed out.

josh
