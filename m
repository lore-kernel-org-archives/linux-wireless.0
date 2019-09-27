Return-Path: <SRS0=tM6R=XW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27258C4360C
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Sep 2019 09:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE6D52054F
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Sep 2019 09:25:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fedux.com.ar header.i=@fedux.com.ar header.b="JhMwdG3i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfI0JZy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Sep 2019 05:25:54 -0400
Received: from mail.fedux.com.ar ([116.203.58.232]:60722 "EHLO
        mail.fedux.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfI0JZy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Sep 2019 05:25:54 -0400
Received: from mail.fedux.com.ar (mail.fedux.com.ar [IPv6:::1])
        by mail.fedux.com.ar (Postfix) with ESMTP id A51D9293A17;
        Fri, 27 Sep 2019 11:25:51 +0200 (CEST)
Authentication-Results: mail.fedux.com.ar; dmarc=pass (p=none dis=none) header.from=fedux.com.ar
Authentication-Results: mail.fedux.com.ar; spf=pass smtp.mailfrom=fedux@fedux.com.ar
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fedux.com.ar;
        s=default; t=1569576351;
        bh=pHFw3kZPffD7Ki2X6Z1VfHBa8iYUBWx9FSVc9wVwjis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JhMwdG3iaVSQP4Y2RjsOWChd+az1TgbcwsxgCI2Eomz6h3LUWqpWg75H/AAoS6Njz
         OVMrGrHhya7TXYFQ4EI+FFGG8Bng4udarl5/ytQdwGMEYxG2lQXZCXcRTl1niPxTdf
         Mcbzcpwb//c7eQiymgcyrguIvn5FGfADTeJB6Uis=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 27 Sep 2019 11:25:51 +0200
From:   Federico Cuello <fedux@fedux.com.ar>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>,
        Miaoqing Pan <miaoqing@codeaurora.org>
Subject: Re: ath10k: Poor performance with kernel 5.3 fixed
In-Reply-To: <87k19vi5fw.fsf@tynnyri.adurom.net>
References: <20190925090856.6964-1-fedux@fedux.com.ar>
 <CA+ASDXOCqZxbASdF4S3z1derWxJO44_hWfdTkjZS0FSoswRvxw@mail.gmail.com>
 <81765f82aaeecc85dea9ce0d6524743e@fedux.com.ar>
 <87k19vi5fw.fsf@tynnyri.adurom.net>
Message-ID: <d046019cbb4a5b3a16357d8d1209ebf5@fedux.com.ar>
X-Sender: fedux@fedux.com.ar
User-Agent: Roundcube Webmail/1.3.10
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-09-26 14:54, Kalle Valo wrote:
> + Miaoqing
> 
> Federico Cuello <fedux@fedux.com.ar> writes:
> 
>> On 2019-09-25 18:24, Brian Norris wrote:
>>> On Wed, Sep 25, 2019 at 2:16 AM Federico Cuello <fedux@fedux.com.ar>
>>> wrote:
>>>> When upgrading to 5.3 my AP started to work really slow. I tracked
>>>> the problem to 4504f0e5b5714d9d26b1a80bf1fc133c95830588 and fixed
>>>> the issue.
>>> 
>>> For the record, that's:
>>> 4504f0e5b571 ath10k: sdio: workaround firmware UART pin
>>> configuration bug
>> 
>> 
>>> 
>>>> The attached patch fixes the issue when uart_print is false and
>>>> uart_pin_workaround also false.
>>> 
>>> -ENOPATCH
>> 
>> Sorry, I sent it in a different email "attached to the thread", but in
>> any case, there was the same fix already applied to kvalo's tree.
>> 
>> Here is the patch and link to already applied fix:
>> 
>>   https://patchwork.kernel.org/patch/11160267/
>> 
>> 
>> It would be great if we can get this to stable, in my case, my WiFi
>> speed went from 150 Mbit/s to 1-5 Mbit/s without this fix.
> 
> I didn't know that the bug was severe and I applied the patch to
> ath-next, which means it will go to v5.5 which is bad. (This is why I
> always ask people to clearly describe the bug in the commit log!)
> 
> In theory I could also push it to v5.4 but I just don't want to deal
> with the possible conflicts coming from duplicate commits.

I don't know how this is affecting others. Miaoqing? How did this affect 
you?

Also, would it be possible maybe to revert the patch and re-apply it 
with stable CCed to avoid any possible conflicts and get it to stable? I 
can still just patch my kernels if this is not big deal for others.
