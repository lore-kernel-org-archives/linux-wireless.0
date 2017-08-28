Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33243 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH1RPS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 13:15:18 -0400
Received: by mail-wm0-f42.google.com with SMTP id b14so14478077wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Aug 2017 10:15:17 -0700 (PDT)
Subject: Re: [PATCH v4] brcmfmac: add CLM download support
To: Steve deRosier <derosier@gmail.com>,
        Wright Feng <wright.feng@cypress.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org, chi-hsien.lin@cypress.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
References: <1503912332-4275-1-git-send-email-wright.feng@cypress.com>
 <CALupW3AWFvGqWDCfvHKkodAMcjf00JrDMHgyuLk3Facg=aqQBA@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <82bb64a9-4ddd-98dd-9068-ddbe9eabb930@broadcom.com> (sfid-20170828_191521_763717_AA2FB66D)
Date: Mon, 28 Aug 2017 19:15:15 +0200
MIME-Version: 1.0
In-Reply-To: <CALupW3AWFvGqWDCfvHKkodAMcjf00JrDMHgyuLk3Facg=aqQBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 28-08-17 16:52, Steve deRosier wrote:
> On Mon, Aug 28, 2017 at 2:25 AM, Wright Feng <wright.feng@cypress.com> wrote:
>> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>>
>> The firmware for brcmfmac devices includes information regarding
>> regulatory constraints. For certain devices this information is kept
>> separately in a binary form that needs to be downloaded to the device.
>> This patch adds support to download this so-called CLM blob file. It
>> uses the same naming scheme as the other firmware files with extension
>> of .clm_blob.
>>
> 
> Not to bikeshed this, but why not just ".clm"?  ".clm_blob" seems
> unnecessary and could feel "unprofessional" to users.
> 
> To me simple seems better.

Hi Steve,

Glad you ask ;-) It was one of my comments pre-reviewing this 
"internally"*. The problem with calling it .clm is that it means 
something else within Broadcom and Cypress for that matter. The 
.clm_blob is the output of tool compiling the regulatory data according 
an input specification which uses the .clm extension. It is similar to 
regdb.txt and regulatory.bin.

Regards,
Arend

* internally does not quite cover Cypress+Broadcom collaboration.
