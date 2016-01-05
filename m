Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:35536 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcAEQKC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 11:10:02 -0500
Subject: Re: [RFC PATCH] staging: rtl8723au: fix byte order problems
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Julian Calaby <julian.calaby@gmail.com>
References: <1451921374-471-1-git-send-email-sven.dziadek@gmx.de>
 <CAGRGNgXxO2ZAGob=p83dNw+98kgZyYKdGcrh8m-vxXo+a7ezMw@mail.gmail.com>
 <wrfj60z8qayn.fsf@redhat.com>
Cc: Sven Dziadek <sven.dziadek@gmx.de>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <568BEAD6.2060406@lwfinger.net> (sfid-20160105_171022_912603_7FFC0DD2)
Date: Tue, 5 Jan 2016 10:09:58 -0600
MIME-Version: 1.0
In-Reply-To: <wrfj60z8qayn.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2016 09:53 AM, Jes Sorensen wrote:
> Julian Calaby <julian.calaby@gmail.com> writes:
>> Hi Sven,
>>
>> On Tue, Jan 5, 2016 at 2:29 AM, Sven Dziadek <sven.dziadek@gmx.de> wrote:
>>> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
>>> index 1662c03c..57f5941 100644
>>> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
>>> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
>>> @@ -93,11 +93,9 @@ int FillH2CCmd(struct rtw_adapter *padapter, u8 ElementID, u32 CmdLen,
>>>
>>>                  if (h2c_cmd & BIT(7)) {
>>>                          msgbox_ex_addr = REG_HMEBOX_EXT_0 + (h2c_box_num * EX_MESSAGE_BOX_SIZE);
>>> -                       h2c_cmd_ex = le16_to_cpu(h2c_cmd_ex);
>>>                          rtl8723au_write16(padapter, msgbox_ex_addr, h2c_cmd_ex);
>>>                  }
>>>                  msgbox_addr = REG_HMEBOX_0 + (h2c_box_num * MESSAGE_BOX_SIZE);
>>> -               h2c_cmd = le32_to_cpu(h2c_cmd);
>>>                  rtl8723au_write32(padapter, msgbox_addr, h2c_cmd);
>>
>> While Jes has NACK'd this change, it does highlight that the h2c_cmd
>> and h2c_cmd_ex variables are being used to hold both cpu-endian and
>> little-endian data. A worthwhile change here might be to move the
>> conversion into the function call following these lines so that they
>> remain "clean".
>>
>> That said, I'm not sure this particular snippet of code would work on
>> big-endian at all as I'm pretty sure that BIT() produces cpu-endian
>> values and we know from the line you remove that h2c_cmd is
>> little-endian at this point.
>
> I am not opposed to cleaning it up, however I hope we can just remove
> all of the code down the line instead. You may want to look at the h2c
> implementation I did for rtl8xxxu. I believe it does work on big-endian,
> at least I know Larry has been able to test it on big-endian systems.

I have tested rtl8xxxu for the RTL8192CU devices on a PowerBook G4 with a 
big-endian processor.

I do not have any RTL8723AU devices that can be tested this way, thus I have no 
idea if either of the drivers work on BE. If I were to guess, I would expect the 
staging driver to fail and rtl8xxxu to work.

Larry


