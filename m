Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E2DC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 03:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2257620657
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 03:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfANDVk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 13 Jan 2019 22:21:40 -0500
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:45908 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfANDVj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 13 Jan 2019 22:21:39 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2019 22:21:39 EST
Received: from gw.sieb.net ([70.70.44.174])
        by shaw.ca with ESMTP
        id isgsgZiZCMRX3isgtgXgfb; Sun, 13 Jan 2019 20:13:31 -0700
X-Authority-Analysis: v=2.3 cv=TL87tGta c=1 sm=1 tr=0
 a=Q8z69UlXDO7VcdJOWsrNQg==:117 a=Q8z69UlXDO7VcdJOWsrNQg==:17
 a=IkcTkHD0fZMA:10 a=3JhidrIBZZsA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=pGutZb4vBWq-5ptj1GsA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
Received: from worklap.sieb.net (worklap.sieb.net [10.0.7.2])
        by gw.sieb.net (Postfix) with ESMTPSA id 4F1B021599
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2019 19:13:30 -0800 (PST)
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     linux-wireless <linux-wireless@vger.kernel.org>
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
 <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
 <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
 <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com>
 <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
From:   Samuel Sieb <samuel@sieb.net>
Message-ID: <da607b13-2934-dcf2-ce5b-eeffcd79bc6c@sieb.net>
Date:   Sun, 13 Jan 2019 19:13:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCFtmoyLQkkd/GVWbyuZ2P0h6xdMYvOFRwTEipfGfOK5rm/7xJBVPaa0UhotuHfK2blL8pnNg5xVLCO5J5afr/kODDdy6bDUWNagWYJoH/CRjDT/t4Er
 aqEeH6bX3NZ9iRGUCHkn54K33P05I+rqivJrMdl7x/DP0Sy8DFni9+zu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/13/19 6:20 PM, Rosen Penev wrote:
> On Sun, Jan 13, 2019 at 11:00 AM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
>>> Could you please double check if IOMMU is enabled?
>>>
>>
>> Have you tried to disable it? Does it make any difference?
> No idea how. UEFI doesn't seem to show anything similar.
> 
> Similar bug report: https://bugzilla.kernel.org/show_bug.cgi?id=202241

As mentioned in that bug report, adding "iommu=off" to the kernel 
command line will disable it.  I think there's also an "iommu=soft" 
option, but I'm not sure what that does.
