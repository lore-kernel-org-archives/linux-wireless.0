Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:39735 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753866AbaJNRP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 13:15:59 -0400
Message-ID: <1413306955.3269.30.camel@joe-AO725> (sfid-20141014_191631_500086_DF86093C)
Subject: Re: [PATCH 1/1 linux-next] zd1201: replace kmalloc/memset by kzalloc
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 14 Oct 2014 10:15:55 -0700
In-Reply-To: <1413304831-7203-1-git-send-email-fabf@skynet.be>
References: <1413304831-7203-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-14 at 18:40 +0200, Fabian Frederick wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

It might be clearer to use a structure for this 16 byte thing.

There's a comment bit in the code:

/* cmdreq message: 
	u32 type
	u16 cmd
	u16 parm0
	u16 parm1
	u16 parm2
	u8  pad[4]

	total: 4 + 2 + 2 + 2 + 2 + 4 = 16
*/

It seems thought that this first u32 is actually
a series of u8s.

Maybe:

struct zd1201_cmdreq {
	u8	type;
	u8	seq;
	u8	a;
	u8	b;
	__le16	cmd;
	__le16	parm0;
	__le16	parm1;
	__le16	parm2;
	u8	pad[4];
};

And does this really need to be alloc'd?

maybe

struct zd1202_cmdreq request = {};

etc...

