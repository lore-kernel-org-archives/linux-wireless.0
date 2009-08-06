Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54008 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbZHFSlM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:41:12 -0400
Subject: Re: CRDA and cross-compilation
From: Pavel Roskin <proski@gnu.org>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jon Loeliger <jdl@bigfootnetworks.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A7B2163.4030805@redfish-solutions.com>
References: <4A7A8F7E.6020503@redfish-solutions.com>
	 <1249569993.6446.2.camel@jdl-desktop>  <1249576886.14919.16.camel@mj>
	 <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>
	 <1249580707.14919.29.camel@mj>  <4A7B2163.4030805@redfish-solutions.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 14:41:11 -0400
Message-Id: <1249584071.19169.7.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-06 at 11:30 -0700, Philip A. Prindeville wrote:

> Dumb question but, why not just build a target and host version each of regdumpdb?

Because it's more complicated.  Because we may want to disable
verification for reasons other than cross-compiling.  Because it's
already possible:

set -e
make verify REG_BIN=/targetfs/regulatory.bin
make clean
make all_noverify CC=cross-gcc

-- 
Regards,
Pavel Roskin
