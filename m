Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568C2C6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 05:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18E992084D
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 05:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18E992084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codewreck.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbeJZNrf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 09:47:35 -0400
Received: from nautica.notk.org ([91.121.71.147]:58599 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbeJZNrf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 09:47:35 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id E8C6FC009; Fri, 26 Oct 2018 07:12:04 +0200 (CEST)
Date:   Fri, 26 Oct 2018 07:11:49 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Ellie Revves <ellierevves@gmail.com>
Subject: Re: ath9k driver may be broken on ARM64 ?
Message-ID: <20181026051149.GA20592@nautica>
References: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
 <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
 <caf394ef-dc52-b19b-6b31-77b92158f389@gmail.com>
 <6c59ee97-cad9-46bb-be0c-6daa6f614a61@gmail.com>
 <CAKR_QVK1t=Fc4F7F+4bNKM+TH3hS6uH_WgfsbK3jmrqSgZGTNg@mail.gmail.com>
 <5aeab3c9-27d7-e0e6-400a-a5373703dff9@gmail.com>
 <CAKR_QVJ1smqU3nr1w4f4SUGjrmcLa0KiAzZn2O6RAyN4MRZ=sQ@mail.gmail.com>
 <52a059ac-fadc-18c9-92a5-e36f64b63ff9@gmail.com>
 <20181025062758.GA24209@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181025062758.GA24209@nautica>
User-Agent: Mutt/1.5.21 (2010-09-15)
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dominique Martinet wrote on Thu, Oct 25, 2018:
> What I find surprising is that the mapping for sc->mem is done (as shown
> in the kernel page table dump), and some REG_WRITE worked before, but
> the first REG_READ fails despite being an aligned address so something
> is odd with how the memory is setup?
> 
> 
> I think it would be interesting to add some debug statement early in
> init (pci init to check how the memory is setup, if I'm not wrong about
> it being pci, and along the path I described earlier) ; but my free time
> ended long ago so don't think I'll be of much more use from now :p

(not sure if you got notified off list, but fwiw the bug is apparently
resolved by upgrading to a newer release of u-boot - same version, from
u-boot 2017.03 armada v17.06 to u-boot 2017.03 armada v17.10
I have no idea what they're doing in u-boot with the memory setup but I
guess the case is closed...)

-- 
Asmadeus | Dominique Martinet
