Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIM_INVALID autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE852C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8239021480
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="INiAf/0n";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QtxQ6FUn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8239021480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbeIYMZu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:25:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeIYMZu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:25:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 643A3607DD; Tue, 25 Sep 2018 06:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537856392;
        bh=hTVCIHMFKQfJN5KVet/O8/RcBL544JDc1CV5TPjAWNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=INiAf/0n83Vcp1MuEvnjWr5UStuvqQcbNg5fvOXIFVJVNH2swlNDibSBJd/7gYJvw
         xyH7H/2/foI3fih3WfU+BeUxDDG+SeLtAJE8IZRt1GyjyW26SgxKzG/ELtUwCDZ0ob
         K7mHyFf9GOR7I+mqVuH2dR5khh7/ojIq4NbnyKeQ=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id BFA74606DC;
        Tue, 25 Sep 2018 06:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537856391;
        bh=hTVCIHMFKQfJN5KVet/O8/RcBL544JDc1CV5TPjAWNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QtxQ6FUnpyre0e4wRCaGzECo/4M6EtoXZVMZSZmIKbbLy/yTgjCaFa9kGywrirZkz
         kLj+RcL4WX1tVCJPpm45H1WGhM0IdHzl/DrjLFrJy0hrk1NNOV8Yvc37Uy88zF3PpE
         on/Yqti8j1kMfiuXzc3+K7QwIia844nwsmNY8dKU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 25 Sep 2018 14:19:51 +0800
From:   Carl Huang <cjhuang@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: download firmware via diag Copy Engine for
 QCA6174 and QCA9377.
In-Reply-To: <20180922005325.GA47003@ban.mtv.corp.google.com>
References: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org>
 <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org>
 <20180922005325.GA47003@ban.mtv.corp.google.com>
Message-ID: <acb99321ba1ca4360295e8f9188df4dd@codeaurora.org>
X-Sender: cjhuang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-22 08:53, Brian Norris wrote:
> Hi again!
> 
> One last (?) comment:
> 
> On Thu, Aug 30, 2018 at 10:29:42AM +0800, Carl Huang wrote:
> 
>> diff --git a/drivers/net/wireless/ath/ath10k/hw.c 
>> b/drivers/net/wireless/ath/ath10k/hw.c
>> index 677535b..25ee1c6 100644
>> --- a/drivers/net/wireless/ath/ath10k/hw.c
>> +++ b/drivers/net/wireless/ath/ath10k/hw.c
> 
>> @@ -918,6 +919,190 @@ static int 
>> ath10k_hw_qca6174_enable_pll_clock(struct ath10k *ar)
> 
>> +static int ath10k_hw_diag_segment_download(struct ath10k *ar,
>> +					   const void *buffer,
>> +					   u32 address,
>> +					   u32 length)
>> +{
>> +	if (address >= DRAM_BASE_ADDRESS + REGION_ACCESS_SIZE_LIMIT)
>> +		/* Needs to change MSB for memory write */
>> +		return ath10k_hw_diag_segment_msb_download(ar, buffer,
>> +							   address, length);
>> +	else
>> +		return ath10k_hif_diag_write(ar, address, buffer, length);
>> +}
>> +
>> +int ath10k_hw_diag_fast_download(struct ath10k *ar,
>> +				 u32 address,
>> +				 const void *buffer,
>> +				 u32 length)
>> +{
>> +	const u8 *buf = buffer;
>> +	bool sgmt_end = false;
>> +	u32 base_addr = 0;
>> +	u32 base_len = 0;
>> +	u32 left = 0;
>> +	struct bmi_segmented_file_header *hdr;
>> +	struct bmi_segmented_metadata *metadata;
>> +	int ret = 0;
>> +
>> +	if (length < sizeof(*hdr))
>> +		return -EINVAL;
>> +
>> +	/* check firmware header. If it has no correct magic number
>> +	 * or it's compressed, returns error.
>> +	 */
>> +	hdr = (struct bmi_segmented_file_header *)buf;
>> +	if (hdr->magic_num != BMI_SGMTFILE_MAGIC_NUM) {
>> +		ath10k_dbg(ar, ATH10K_DBG_BOOT,
>> +			   "Not a supported firmware, magic_num:0x%x\n",
>> +			   hdr->magic_num);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (hdr->file_flags != 0) {
>> +		ath10k_dbg(ar, ATH10K_DBG_BOOT,
>> +			   "Not a supported firmware, file_flags:0x%x\n",
>> +			   hdr->file_flags);
>> +		return -EINVAL;
>> +	}
>> +
>> +	metadata = (struct bmi_segmented_metadata *)hdr->data;
>> +	left = length - sizeof(*hdr);
>> +
>> +	while (left > 0) {
>> +		base_addr = metadata->addr;
>> +		base_len = metadata->length;
>> +		buf = metadata->data;
>> +		left -= sizeof(*metadata);
>> +
>> +		switch (base_len) {
> ...
>> +		default:
>> +			if (base_len > left) {
>> +				/* sanity check */
>> +				ath10k_warn(ar,
>> +					    "firmware has invalid segment length, %d > %d\n",
>> +					    base_len, left);
>> +				ret = -EINVAL;
>> +				break;
>> +			}
>> +
>> +			ret = ath10k_hw_diag_segment_download(ar,
>> +							      buf,
>> +							      base_addr,
>> +							      base_len);
> 
> This 'base_len' is determined by the firmware blob and in common cases
> is over 500K. The PCI implementation currently tries to
> dma_alloc_coherent() a bounce buffer for this. Many systems can't
> acquire that large of contiguous DMA memory reliably, so this is isn't
> very effective. Can we improve the strategy here? Do you lose a lot of
> speed if you do this in smaller (a few pages?) chunks instead?
> 

It's a sound complaint. I'll submit a patch for it.


> Brian
> 
>> +
>> +			if (ret)
>> +				ath10k_warn(ar,
>> +					    "failed to download firmware via diag interface:%d\n",
>> +					    ret);
>> +			break;
> ...
