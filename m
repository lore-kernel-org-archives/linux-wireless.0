Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:58355 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583Ab0A1WIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 17:08:20 -0500
Message-ID: <4B620AD1.8010908@redfish-solutions.com>
Date: Thu, 28 Jan 2010 14:08:17 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Subject: Re: Hacking documentation updated for compat-wireless
References: <43e72e891001221318p695f0923hea4f3573cedbd78d@mail.gmail.com> 	<4B61E530.1060008@redfish-solutions.com> <43e72e891001281313g796316f9t4708f9fbc8853a10@mail.gmail.com>
In-Reply-To: <43e72e891001281313g796316f9t4708f9fbc8853a10@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2010 01:13 PM, Luis R. Rodriguez wrote:
> On Thu, Jan 28, 2010 at 11:27 AM, Philip A. Prindeville
> <philipp_subx@redfish-solutions.com> wrote:
>> On 01/22/2010 01:18 PM, Luis R. Rodriguez wrote:
>>> I've updated the hacking documentation for compat-wireless, please let
>>> me know if there are any questions:
>>>
>>> http://wireless.kernel.org/en/users/Download/hacking
>>>
>>>   Luis
>>
>> Hi Luis,
>>
>> Finally got around to reading this.  A couple of things weren't clear to me.
>>
>> On the page, if the $HOME is assumed to be /home/user, then:
>>
>> $HOME/wireless-testing is where the generated snapshot is left;
>>
>> the "git clone" of linux-next, compat, and compat-wireless-2.6 all happen directly in $HOME;
>>
>> Running this, however, doesn't work:
>>
>> [philipp@builder ~/cw]$ env | grep GIT
>> GIT_TREE=/home/philipp/cw/wireless-testing
> 
> GIT_TREE should be your linux-next tree not wireless-testing tree.
> 
>   Luis

Ok, you might want to correct the Wiki then.

Also, in a cross-building environment, I'm not sure why admin-clean.sh mucks with the host's kernel sources:

$ scripts/admin-clean.sh
cat: /home/philipp/cw/compat-wireless-2.6/compat-release: No such file or directory
cat: /home/philipp/cw/compat-wireless-2.6/compat-release: No such file or directory
make[1]: Entering directory `/usr/src/kernels/2.6.32.4-30.fc12.x86_64'
scripts/Makefile.clean:17: /home/philipp/cw/compat-wireless-2.6/drivers/bluetooth/Makefile: No such file or directory
make[3]: *** No rule to make target `/home/philipp/cw/compat-wireless-2.6/drivers/bluetooth/Makefile'.  Stop.
make[2]: *** [/home/philipp/cw/compat-wireless-2.6/drivers/bluetooth] Error 2
make[1]: *** [_clean_/home/philipp/cw/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.32.4-30.fc12.x86_64'
make: *** [clean] Error 2
Cleaned wireless-bt-compat-2.6
$




