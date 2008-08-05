Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:44218 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbYHEXxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 19:53:51 -0400
Received: by ik-out-1112.google.com with SMTP id c28so3275194ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 16:53:49 -0700 (PDT)
Message-ID: <4898E668.9020604@gmail.com> (sfid-20080806_015355_583489_5BC476B2)
Date: Wed, 06 Aug 2008 00:46:48 +0100
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>	 <1217822232.10989.13.camel@dv>  <48978C25.601@gmail.com> <1217977166.19480.2.camel@dv>
In-Reply-To: <1217977166.19480.2.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Tue, 2008-08-05 at 00:09 +0100, Dave wrote:
>> Actually I meant the DECLARE_DEFAULT_PDA macro in hermes_dld.c:
                        ^^ DEFINE obviously.

>> dkilroy@borken /usr/src/wireless-testing $ git diff HEAD~20 | scripts/checkpatch.pl -
>> ERROR: Macros with multiple statements should be enclosed in a do - while loop
>> #933: FILE: drivers/net/wireless/hermes_dld.c:570:
>> +#define DEFINE_DEFAULT_PDR(pid, length, data)				\
>> +static const struct {							\
>> +	__le16 len;							\
>> +	__le16 id;							\
>> +	u8 val[length];							\
>> +} __attribute__ ((packed)) default_pdr_data_##pid = {			\
>> +	__constant_cpu_to_le16((sizeof(default_pdr_data_##pid)/		\
>> +				sizeof(__le16)) - 1),			\
>> +	__constant_cpu_to_le16(pid),					\
>> +	data								\
>> +}
> 
> I suggest that you take the structure definition outside the macro and
> give it a reasonable name.

The reason for defining it in this manner is to ensure the data is consistent. For those that are interested, this code is at the end of patch 08/19.

It allows (using pid 0x0005 and dummy data as an example throughout):

DEFINE_DEFAULT_PDR(0x0005, 7, "\x00\x01\x02\x03\x04\x05\x06");

instead of:

#define DEFINE_PDR(pid, len, data)                                      \
        __constant_cpu_to_le16((len/		                        \
				sizeof(__le16)) - 1),			\
	__constant_cpu_to_le16(pid),					\
	data

struct {
 __le16 len;
 __le16 id;
 u8 val[7];
} __attribute__ ((packed)) named_pdr = {
	DEFINE_PDR(0x0005, 7, "\x00\x01\x02\x03\x04\x05\x06")
};

or

#define DECLARE_PDA(len)
struct {                     \
 __le16 len;                 \
 __le16 id;                  \
 u8 val[7];                  \
} __attribute__ ((packed))

DECLARE_PDA(7) named_pdr = {
	DEFINE_PDR(0x0005, 7, "\x00\x01\x02\x03\x04\x05\x06")
};

There are 5 or 6 different structures declared in this manner, one for each pid. In one case the data element is 256 bytes. I think that the style in the patch is easier on the eye, and less likely to become inconsistent over time. It would be even better if I could omit the length and just provide pid and data, but I can't see how to do that.

The user only needs to know the variable name if trying to find it in a debugger or map file, since there is a

#define DEFAULT_PDR(pid) default_pdr_data_##pid 

The mapping from pid to functionality is then entirely restricted to where the definition occurs. The switch statement in hermes_apply_pdr_with_defaults is a straight pid to pid mapping, with comments just to keep track. If desired I can add

#define HWIF_COMPAT 0x0005

to use in place of wherever I've used 0x0005. The variable will end up being called default_pdr_data_HWIF_COMPAT, and everything else is unchanged.


Please provide an example of how you think the above could be done better - I've tried several things, and I still think that what is in the patch is the neatest.


Regards,

Dave.
