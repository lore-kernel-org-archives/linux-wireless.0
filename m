Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:43504 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755004AbcJLOMq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 10:12:46 -0400
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        David Hutchison <dhutchison@bluemesh.net>
References: <CA+i30h8YsG7mce5FMwGw2fRNAn3USYV6K==QMjMQVeSGB0dj=w@mail.gmail.com>
 <8760oxfzg4.fsf@kamboji.qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <040abb8b-d57b-63f9-43ec-da7e12b87bc6@dd-wrt.com> (sfid-20161012_161250_410997_782B40F7)
Date: Wed, 12 Oct 2016 16:12:39 +0200
MIME-Version: 1.0
In-Reply-To: <8760oxfzg4.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Subject: Re: QCA9887 Firmware Memory Usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 12.10.2016 um 15:51 schrieb Valo, Kalle:
> David Hutchison <dhutchison@bluemesh.net> writes:
>
>> I am using a Mikrotik hAP AC Lite which has a QCA9887 radio. It
>> appears to be working; however ath10k ( or the qca9887 firmware ) is
>> utilizing 15 - 20mb of memory. I applied the kfree(caldata) patch, to
>> insure there is no memory leak.
>>
>> It doesn't appear to be leaking, and it will run Ok with the high
>> memory footprint. However the Mikrotik hAP AC Lite is only a 64mb
>> platform; so when I initialize the 2nd radio with ath9k I get OOMs.
>>
>> It just doesn't seem right that when ath10k + qca9887 is in AP mode
>> that it's utilizing as much memory as it is. I don't think the issue
>> is with ath10k, I think it's the qca9887 firmware (
>> firmware-5.bin_10.2.4-1.0-00013 ).
>>
>> Is there a newer build available that may potentially fix these memory
>> issues? The latest one available on
>> https://github.com/kvalo/ath10k-firmware/blob/master/QCA9887/hw1.0/firmware-5.bin_10.2.4-1.0-00013
>> is 2 months old. Perhaps there is a newer build to test that may have
>> the fix?
>>
>> Any thoughts as to what it could be? I can provide more information if needed.
> 64MB of RAM nowadays is not much and ath10k is not really tested in such
> setups AFAIK. I guess you could try if reducing TARGET_10X_NUM_MSDU_DESC
> helps with the memory consumption, but no idea if that would even work
> without further modifications to ath10k.
>
> Also if you have fq-codel&co enabled that might increase memory
> consumption. Adding linux-wireless as people there might have better
the high memory consumption is a very common old problem. and no, 64 mb 
might not by much. but consider that qca9880 cards for instance are only 
used on embedded devices.
there is not even a windows driver available for it. its mainly used in 
routers and 64 mb ram is not uncommon here.
the problem with qca9887 sounds similar here. and the best. it only 
occures on ath10k. with the closed source qca driver it will work on 
embedded platforms. since
it was mentioned that this problem is caused by the firmware itself. so 
there wont be a solution until qca is finally getting in touch with this 
problem
> ideas.
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
