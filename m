Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47288 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaJMIpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 04:45:20 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so6733916wid.6
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2014 01:45:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bnpg9yvh.fsf@kamboji.qca.qualcomm.com>
References: <1412847527-25983-1-git-send-email-michal.kazior@tieto.com>
	<1412847527-25983-3-git-send-email-michal.kazior@tieto.com>
	<87bnpg9yvh.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 13 Oct 2014 10:45:18 +0200
Message-ID: <CA+BoTQn035S9KvuoJw6vNnbPsqyLJJK_svPu7W0XAXumkJU09g@mail.gmail.com> (sfid-20141013_104522_949001_EA6E6207)
Subject: Re: [PATCH 2/3] ath10k: expose hw restart via debugfs
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 October 2014 10:07, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
[...]
>> --- a/drivers/net/wireless/ath/ath10k/debug.c
>> +++ b/drivers/net/wireless/ath/ath10k/debug.c
>> @@ -694,7 +694,8 @@ static ssize_t ath10k_read_simulate_fw_crash(struct file *file,
>>               "To simulate firmware crash write one of the keywords to this file:\n"
>>               "`soft` - this will send WMI_FORCE_FW_HANG_ASSERT to firmware if FW supports that command.\n"
>>               "`hard` - this will send to firmware command with illegal parameters causing firmware crash.\n"
>> -             "`assert` - this will send special illegal parameter to firmware to cause assert failure and crash.\n";
>> +             "`assert` - this will send special illegal parameter to firmware to cause assert failure and crash.\n"
>> +             "`request` - this will simply queue hw restart without fw/hw actually crashing.\n";
>
> "request" is not really very descriptive command. Maybe call it
> "hw-restart" because that's what it really does, right?

Good idea. I'll rename it.


Michał
