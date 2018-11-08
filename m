Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E215ECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 19:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C73B2081C
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 19:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="adnew7e4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="adnew7e4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C73B2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbeKIF3x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 00:29:53 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45642 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725199AbeKIF3x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 00:29:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D1EA4601D7; Thu,  8 Nov 2018 19:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541706773;
        bh=XFpxOxE45vJ85tfFSq2rlEM5qRaOaNKq5Ty6GNRkpPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=adnew7e4AIIJ3f7UHSnHTHcP8mBBq14vF3nj+LG1RJw1piOyGp+xQsYWQMIgC0znN
         goTxSw4xpS931P0lhEs1QOaAlWQPq8wBKE41kSbpcspdJDRaDsyRdvDVtacykda+Dl
         6xaGpOEZyTF1gP2OLjNVrC8lPa/wXiIFfFkIXeXU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 620886029D;
        Thu,  8 Nov 2018 19:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541706773;
        bh=XFpxOxE45vJ85tfFSq2rlEM5qRaOaNKq5Ty6GNRkpPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=adnew7e4AIIJ3f7UHSnHTHcP8mBBq14vF3nj+LG1RJw1piOyGp+xQsYWQMIgC0znN
         goTxSw4xpS931P0lhEs1QOaAlWQPq8wBKE41kSbpcspdJDRaDsyRdvDVtacykda+Dl
         6xaGpOEZyTF1gP2OLjNVrC8lPa/wXiIFfFkIXeXU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 08 Nov 2018 11:52:53 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     govinds@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        yyuwang@codeaurora.org, pillair@codeaurora.org,
        stable <stable@vger.kernel.org>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH REGRESSION] Revert "ath10k: add quiet mode support for
 QCA6174/QCA9377"
In-Reply-To: <CA+ASDXOqJ1-G2amyu7sJCnzKf1oY_2j9Qw4WS0VTf8EqGr6Uqw@mail.gmail.com>
References: <20181107185643.240346-1-briannorris@chromium.org>
 <7f2ef494f4a2aba1845a157da8fec449@codeaurora.org>
 <b1a64bd66fa25f274af8c018c6fc02f4@codeaurora.org>
 <CA+ASDXOqJ1-G2amyu7sJCnzKf1oY_2j9Qw4WS0VTf8EqGr6Uqw@mail.gmail.com>
Message-ID: <f1abeef79b579f91850cab298a32fe00@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-08 09:30, Brian Norris wrote:
> On Wed, Nov 7, 2018 at 8:32 PM Govind Singh <govinds@codeaurora.org> 
> wrote:
>> On 2018-11-08 03:00, Rajkumar Manoharan wrote:
>> >
>> > The change "ath10k: add quiet mode support for QCA6174/QCA9377" was
>> > merged even
>> > before full WCN3990 device support was added in ath10k. How come it
>> > could be regression
>> > for WCN3990. I know both are sharing same WMI-TLV interface but
>> > reverting this
>> > will break QCA6174/QCA9377. no?
> 
> I don't see how the revert would "break" QCA6174 -- QCA6174 worked
> just fine without this feature and should continue to do so.
> 

I meant that the revert commit remove quiet mode support from QCA6174 & 
QCA9377.

>> This regression is found while we switched from 4.18 + WCN3990
>> back-ports to 4.19.
> 
> ^^ What Govind said. WCN3990 support has been trickling in over a few
> releases, and it doesn't seem kosher to allow people to submit
> regressions in the midst of that.
> 
Nobody prefers regression :). WCN3990 support was still in progress, at
the time the commit got merged into upstream. My point is that we can't 
expect
the community to validate the changes against in-progress platform.

>> 
>> IMO, we should use (WMI_SERVICE_THERMAL_MGMT | WMI_SERVICE_THERM_THROT 
>> )
>> service bitmap check and call
>> ath10k_thermal_set_throttling only if fw supports THERMAL THROTTLE
>> feature. But we need to ensure all
>> available ath10k fw's are reporting this service.
> 
> And the above notes from Govind highlight this -- if the feature was
> not protected by the appropriate service flags, then we can't be sure
> that you didn't break a bunch of other firmware releases out there.
> Linux should not break for everyone just because you spun a firmware
> release.
> 
That is true. Any new features or interface changes in firmware will be
advertised by feature bit. But the quiet param was available in firmware
since first release.

> Of course, I'll leave it up to Kalle as to how he wants to mediate
> this. And if you come up with a solid patch soon that can fix this
> without dropping the feature, then so be it.
> 
Govind is working on to handle this properly either by instantiating
new WMI-TLV table for WCNxxxx or by adding conditional check in exiting 
path.

-Rajkumar
