Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:59829 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753511Ab2BJJdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 04:33:08 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 27422-03 for <linux-wireless@vger.kernel.org>;
 Fri, 10 Feb 2012 09:33:05 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH net-next] drivers/net: Remove boolean comparisons to true/false
Date: Fri, 10 Feb 2012 09:32:39 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E65@saturn3.aculab.com> (sfid-20120210_103325_927025_FF43B054)
In-Reply-To: <1328822243.29329.11.camel@joe2Laptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Joe Perches" <joe@perches.com>,
	"David Miller" <davem@davemloft.net>
Cc: <jeffrey.t.kirsher@intel.com>, <netdev@vger.kernel.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> -	u32 func_encode = func |
> -			((is_Pf == true ? 1 : 0) <<
IGU_FID_ENCODE_IS_PF_SHIFT);
> +	u32 func_encode = func | (is_Pf ? 1 : 0) <<
IGU_FID_ENCODE_IS_PF_SHIFT;

This sort of thing is why I personally don't like 'bool' at all.
If 'is_Pf' were an integer type that is known to only contain 0 or 1
then the code can just be:
	u32 func_encode = func | is_Pf << IGU_FID_ENCODE_IS_PF_SHIFT;
although that is still valid when is_Pf is bool, the compiler
is required to generate code on every access that converts
all non-zero values to 1 - so the generated code is likely
to be 'is_Pf ? 1 : 0'.

The generated code is particularly horrid for boolean arithmetic.
IIRC:
   bool_var &= bool_var_1;
typically requires a sequence of compare and branch instructions.

	David


