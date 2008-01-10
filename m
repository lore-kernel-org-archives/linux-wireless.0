Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbYAJUtl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 15:49:41 -0500
Message-ID: <4786849D.4010504@redhat.com> (sfid-20080110_204944_741931_CC60F748)
Date: Thu, 10 Jan 2008 15:48:29 -0500
From: Chuck Ebbert <cebbert@redhat.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Roel Kluin <12o3l@tiscali.nl>, linville@tuxdriver.com,
	lkml <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless/arlan] Replace logical- by bit-and
References: <4722453E.2090801@tiscali.nl>	<472248AC.7080201@tiscali.nl>	<47866EE9.80003@tiscali.nl> <20080110122859.569b3774.randy.dunlap@oracle.com>
In-Reply-To: <20080110122859.569b3774.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2008 03:28 PM, Randy Dunlap wrote:
> On Thu, 10 Jan 2008 20:15:53 +0100 Roel Kluin wrote:
> 
>> Totally untested patch below from linus' git tree. The && is incorrect, right?
>>
>> from drivers/net/wireless/arlan.h:390:
>> #define ARLAN_POWER             0x40
>> #define ARLAN_ACCESS            0x80
>>
>> Replace logical and by bit-and
>>
>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>> ---
>> diff --git a/drivers/net/wireless/arlan.h b/drivers/net/wireless/arlan.h
>> index 3ed1df7..7b7498f 100644
>> --- a/drivers/net/wireless/arlan.h
>> +++ b/drivers/net/wireless/arlan.h
>> @@ -485,7 +485,7 @@ struct arlan_private {
>>  #define clearClearInterrupt(dev){\
>>     writeControlRegister(dev,readControlRegister(dev) & ~ARLAN_CLEAR_INTERRUPT);}
>>  #define setPowerOff(dev){\
>> -   writeControlRegister(dev,readControlRegister(dev) | (ARLAN_POWER && ARLAN_ACCESS));\
>> +   writeControlRegister(dev, readControlRegister(dev) | (ARLAN_POWER & ARLAN_ACCESS));\
> 
> eh?  How does that help?
> 
> 0x80 && 0x40 -> 0

1
