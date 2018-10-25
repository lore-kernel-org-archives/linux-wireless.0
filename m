Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE11C46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 06:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FF452082E
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 06:33:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FF452082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codewreck.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbeJYPEl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 11:04:41 -0400
Received: from nautica.notk.org ([91.121.71.147]:60082 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbeJYPEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 11:04:41 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2018 11:04:40 EDT
Received: by nautica.notk.org (Postfix, from userid 1001)
        id A8FEBC009; Thu, 25 Oct 2018 08:28:13 +0200 (CEST)
Date:   Thu, 25 Oct 2018 08:27:58 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Ellie Revves <ellierevves@gmail.com>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: ath9k driver may be broken on ARM64 ?
Message-ID: <20181025062758.GA24209@nautica>
References: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
 <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
 <caf394ef-dc52-b19b-6b31-77b92158f389@gmail.com>
 <6c59ee97-cad9-46bb-be0c-6daa6f614a61@gmail.com>
 <CAKR_QVK1t=Fc4F7F+4bNKM+TH3hS6uH_WgfsbK3jmrqSgZGTNg@mail.gmail.com>
 <5aeab3c9-27d7-e0e6-400a-a5373703dff9@gmail.com>
 <CAKR_QVJ1smqU3nr1w4f4SUGjrmcLa0KiAzZn2O6RAyN4MRZ=sQ@mail.gmail.com>
 <52a059ac-fadc-18c9-92a5-e36f64b63ff9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52a059ac-fadc-18c9-92a5-e36f64b63ff9@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ellie Revves wrote on Thu, Oct 25, 2018:
> Here's another boot log along with some commands after the system
> booted up to show what I did. I don't think I did anything wrong,
> and yet this is no different, debug option appears to be completely
> useless.

I'm not familiar with ath at all, just happened to be free at the time
this was brought up on IRC (#linux-wireless), so can relate what we said
there after looking at the debug symbols to interprete the stack a bit
further. It seems to fail before any print, honestly.

In the stack trace, x17 (0x4020) is reg_offset, so looking from the
value I think it would be AR_INTR_SYNC_CAUSE which should be in some
path like this inlined in ath9k_hw_init -> __ath9k_hw_init ->
ath9k_hw_set_reset_reg -> ath9k_hw_set_reset_power_on ->
ath9k_hw_set_reset -> tmpReg = REG_READ(ah, AR_INTR_SYNC_CAUSE);


The only thing that would have happened before is the ath_pci_probe call
that sets up the memory but even that doesn't log anything.

What I find surprising is that the mapping for sc->mem is done (as shown
in the kernel page table dump), and some REG_WRITE worked before, but
the first REG_READ fails despite being an aligned address so something
is odd with how the memory is setup?


I think it would be interesting to add some debug statement early in
init (pci init to check how the memory is setup, if I'm not wrong about
it being pci, and along the path I described earlier) ; but my free time
ended long ago so don't think I'll be of much more use from now :p

-- 
Dominique Martinet | Asmadeus
