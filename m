Return-Path: <SRS0=etsy=AN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31C9C433DF
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jul 2020 19:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F9D12088E
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jul 2020 19:50:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wildgooses.com header.i=@wildgooses.com header.b="ChdaYaWP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgGBTuo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 2 Jul 2020 15:50:44 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:40482 "EHLO
        mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBTuo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Jul 2020 15:50:44 -0400
Received: from macbookpro-ed.wildgooses.lan (unknown [212.69.38.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: ed@wildgooses.com)
        by mail1.nippynetworks.com (Postfix) with ESMTPSA id 49yTGn5ZqszTgRK;
        Thu,  2 Jul 2020 20:50:41 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wildgooses.com;
        s=dkim; t=1593719441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ka76Ba7LX/kNZZOMIvz3Uze8lwfFYiBWcKWYSVrMX2w=;
        b=ChdaYaWPbX7yAXkYhYYxSQxkzK+rbwulO7X1pkvUr2KWLU2nri+jMW9gRmAttsTybkxD1C
        lEgChbnE0lRvI49kcYLhd7uS1BpDlRVQZxeO8O/R4ARGJsScoveZpcHKwlYX9qRNubA+Tk
        wci5SBMVaBvqSEQ6upuRnIZc+/R5ELY=
From:   Ed W <lists@wildgooses.com>
Subject: Correction of wireless-regdb for GB
To:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
X-Tagtoolbar-Keys: D20200702205041285
Message-ID: <4d07581c-a3be-a3c6-bf32-7007eb45d541@wildgooses.com>
Date:   Thu, 2 Jul 2020 20:50:41 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi, I think that the wireless regdb for GB domain can be corrected:

According to Ofcom, in 2017 the rules were updated for the 5725-5850Ghz=20
range to allow a power output of 200mW (the max power output is much=20
higher still for fixed wireless where a =C2=A350 licence is purchased)

Reference to the latest Ofcom document is here (IR-2030):

https://www.ofcom.org.uk/__data/assets/pdf_file/0028/84970/ir-2030.pdf


My reading of this is that DFS is currently required and I *assume* also =

the wmm would be the same as the rest of the range. I'm not sure if this =

rule needs an AUTO-BW?

(Note also that Ofcom opened a proposal to remove the DFS requirement on =

this frequency band (and to add new 5Ghz bands). Results of this are due =

later in 2020.)


Therefore I think that the db.txt should say:


|

country GB: DFS-ETSI
=2E..

	# Reference (IR-2030)
	(5725 - 5875 @ 80), (200 mW), DFS, AUTO-BW, wmmrule=3DETSI

|

|Could someone appropriate please check this and update upstream.|

|
|

|Thanks|

|Ed W
|

||

