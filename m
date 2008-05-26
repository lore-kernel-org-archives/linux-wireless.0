Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27979 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYEZJ0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 05:26:55 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 2] libertas: fix compact flash interrupt handling
Date: Mon, 26 May 2008 11:26:49 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200805231605.04168.hs4233@mail.mn-solutions.de> <1211566566.12312.4.camel@localhost.localdomain>
In-Reply-To: <1211566566.12312.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805261126.49199.hs4233@mail.mn-solutions.de> (sfid-20080526_112658_886280_D88E4C70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Weird error.

However, I just seem to fix my "hard lockups". In 
if_cs_send_data() I need to call if_cs_disable_ints() / 
if_cs_enable_ints(). After I did this, I can now run "scp 
test.iso 10.2.1.4:/tmp" and "while true; do iwconfig eth1; sleep 
0.2; done" simultanously.
