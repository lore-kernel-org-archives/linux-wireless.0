Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26952C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 23:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E86ED20B1F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 23:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548976992;
	bh=uYBTf/CKCQr+AnK5BEFBgj7ENsxBQSSUo9c5Wzz1QPI=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=o1M2NqmnffbH7lbmUc+90nF15eQR89SAeiSqZlImCFRpAm0Sammz7uJ2UixQUR/Ka
	 vtWH9qzULblijlrOjQXX84O1iZS6L7q2x+xlry+iv/a/162zDhzwdo6a9ueEPtxBnB
	 9SL3R3Zf1OYjyUZ+HwxPhkF1ndBvrl5XrRPC1jL4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfAaXXF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 18:23:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbfAaXXF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 18:23:05 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47E0820881;
        Thu, 31 Jan 2019 23:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548976984;
        bh=uYBTf/CKCQr+AnK5BEFBgj7ENsxBQSSUo9c5Wzz1QPI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=vm7UhEWzGAJAuLABuZu1dekrtjpLyoP4WNdkp8TGfjrGuwAmj7WH+Hr8OVkSWDNWI
         24cR40eWZXFKhQnpOuFOPj42OEXv4A8X3rrSTuyplVTwEwXw22OWHsEtlKu1ZccfD+
         stBvphqqtSzkXbimLUCW+17Voj7mvQ2PlxrtxwFk=
Subject: Re: [PATCH] tty: Fix WARNING in tty_set_termios
To:     Johan Hovold <johan@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        chris@the-brannons.com, devel@driverdev.osuosl.org,
        Rob Herring <robh@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.com>, santhameena13@gmail.com,
        kirk@reisers.ca, Johan Hedberg <johan.hedberg@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, samuel.thibault@ens-lyon.org,
        m.maya.nakamura@gmail.com, zhongjiang@huawei.com,
        Greg KH <gregkh@linuxfoundation.org>,
        speakup@linux-speakup.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        nishka.dasgupta_ug18@ashoka.edu.in,
        "David S. Miller" <davem@davemloft.net>, shuah <shuah@kernel.org>
References: <20190125232905.21727-1-shuah@kernel.org>
 <20190126041416.GF2217@ZenIV.linux.org.uk>
 <fe4018a7-19e4-cdd1-3095-bbe88a82788e@kernel.org>
 <20190130103227.GR3691@localhost>
 <D0EE5C33-2930-4286-998C-822DD7898B76@holtmann.org>
 <20190131153306.GT3691@localhost>
From:   shuah <shuah@kernel.org>
Message-ID: <2812690e-d9d6-9755-ecb1-045e2acb4323@kernel.org>
Date:   Thu, 31 Jan 2019 16:23:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190131153306.GT3691@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/31/19 8:33 AM, Johan Hovold wrote:
> On Thu, Jan 31, 2019 at 04:18:33PM +0100, Marcel Holtmann wrote:
> 
>>> I agree with Al that this change doesn't make much sense. The WARN_ON
>>> is there to catch any bugs leading to the termios being changed for a
>>> master side pty. Those should bugs should be fixed, and not worked
>>> around in order to silence a WARN_ON.
>>>
>>> The problem started with 7721383f4199 ("Bluetooth: hci_uart: Support
>>> operational speed during setup") which introduced a new way for how
>>> tty_set_termios() could end up being called for a master pty.
>>>
>>> As Al hinted at, setting these ldiscs for a master pty really makes no
>>> sense and perhaps that is what we should prevent unless simply making
>>> sure they do not call tty_set_termios() is sufficient for the time
>>> being.
>>>
>>> Finally, note that serdev never operates on a pty, and that this is only
>>> an issue for (the three) line disciplines.
>>
>> I think for PTYs we should just fail setting the HCI line discipline.
>> Fail early and just move on with life.
> 
> Sounds good to me. At least for the pty master. There may be some people
> trying to use a bluetooth device connected to a remote serial port (I've
> seen descriptions of such setups at least), and maybe we need not prevent
> that.
> 

Thanks for the feedback on the patch. Changes to prevent setting the HCI
line discipline from hci_uart fixes the problem.

I am sending v2 in a just a bit.

thanks,
-- Shuah

