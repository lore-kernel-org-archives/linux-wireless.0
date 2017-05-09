Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34999 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbdEIMIF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 08:08:05 -0400
Received: by mail-pg0-f51.google.com with SMTP id o3so51971294pgn.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 05:08:05 -0700 (PDT)
Subject: Re: [PATCH] net: wireless: ath: ath10k: remove unnecessary code
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
References: <20170509042159.GA19727@embeddedgus>
 <87lgq6387s.fsf@kamboji.qca.qualcomm.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <76408651-07c6-fe31-863f-e1cb73b49663@broadcom.com> (sfid-20170509_140848_005042_5F5F6BCC)
Date: Tue, 9 May 2017 14:07:57 +0200
MIME-Version: 1.0
In-Reply-To: <87lgq6387s.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9-5-2017 7:33, Kalle Valo wrote:
> "Gustavo A. R. Silva" <garsilva@embeddedor.com> writes:
> 
>> The name of an array used by itself will always return the array's address.
>> So these tests will always evaluate as false and therefore the _return_
>> will never be executed.
>>
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> 
> I don't understand the commit log, especially what does "The name of an
> array used by itself" mean?

The array fields in struct wmi_start_scan_arg that are checked here are
fixed size arrays so they can never be NULL.

Maybe that helps rephrasing this commit message.

Regards,
Arend
