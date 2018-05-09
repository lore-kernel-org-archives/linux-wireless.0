Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52032 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbeEIECd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 00:02:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 09 May 2018 09:32:32 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 00/12] *** Add support for wifi QMI client driver ***
In-Reply-To: <20180508173710.GL2259@tuxbook-pro>
References: <1522042636-25516-1-git-send-email-govinds@codeaurora.org>
 <20180508173710.GL2259@tuxbook-pro>
Message-ID: <e0a9a4fd755f04a7e7068544ebc95890@codeaurora.org> (sfid-20180509_060237_630583_A9B793CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-08 23:07, Bjorn Andersson wrote:
> On Sun 25 Mar 22:37 PDT 2018, Govind Singh wrote:
> 
>> Add QMI client driver for Q6 integrated WLAN connectivity subsystem.
>> This module is responsible for communicating WLAN control messages to 
>> FW
>> over QMI interface.
>> 
>> “QUALCOMM Messaging Interface”(QMI) provides the control interface 
>> between
>> components running b/w remote processors with underlying transport 
>> layer
>> based on integrated chipset(shared memory) or discrete 
>> chipset(PCI/USB/SDIO/UART).
>> 
>> QMI client driver implementation is based on qmi frmework 
>> https://lwn.net/Articles/729924/.
>> 
>> Below is the sequence of qmi handshake.
>> 
>>        QMI CLIENT(APPS)                                         QMI 
>> SERVER(FW in Q6)
>> 
>>                          <------wlan service discoverd----
>> 
>>                        -----connect to wlam qmi service----->
>> 
>>                        ------------wlan info request----->
>> 
>>                        <------------wlan info resp------------
>> 
>>                        ------------msa info req-------->
>> 
>>                      <------------msa info resp------------
>> 
>>                      ------------msa ready req-------->
>> 
>>                      <------------msa ready resp------------
>> 
>>                      <------------msa ready indication-------
>> 
>>                      ------------capability req------->
>> 
>>                     <------------capability resp------------
>> 
>>                     ------------qmi bdf req--------->
>> 
>>                      <------------qmi bdf resp------------
>> 
>>                       ------------qmi cal trigger------->
>> 
>>                   <------------ QMI FW ready indication-------
> 
> Does the responsibility of the driver ends here? I mean is this a 
> driver
> for setting up the firmware and then there's something else doing the
> actual wifi operation, or does it simply hand over execution to the
> common ath10k logic at this point?
> 

 From wlan qmi client point of view once wlan qmi service is discovered, 
it connects to the service and
does the above handshakes and later it handover the execution to common 
ath10k logic.
These handshakes will be done as part of pd restart as well.

>> 
>> Govind Singh (12):
>>   ath10k: Add qmi service for wlan qmi client
>>   dt: bindings: add bindings for ath10k qmi client
>>   ath10k: Add WCN3990 QMI client driver
>>   ath10k: add support to start and stop qmi service
>>   ath10k: Add support of QMI indication message
>>   firmware: qcom: scm: Add WLAN VMID for Qualcomm SCM interface
>>   ath10k: Add MSA handshake QMI mgs support
>>   ath10k: Add QMI CAP request support
>>   ath10k: Add QMI HOST CAP request support
>>   ath10k: add bdf/cal indication support
>>   ath10k: Add wlan mode on/off qmi message
>>   ath10k: Add qmi wlan enable/disable support for WCN3990
> 
> I'm missing this last patch in my mailbox, and it would be nice if all
> the patches where in-reply-to the cover letter, to make them easier to
> find.
> 
> Regards,
> Bjorn

Sure, I will take care this while submitting next version of this patch 
series.

BR,
Govind
