Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:33588 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753476Ab1ARDKr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 22:10:47 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 17 Jan 2011 19:07:39 -0800
Subject: RE: [PATCH] mwifiex: remove duplicated NULL checks
Message-ID: <477F20668A386D41ADCC57781B1F704307F4E1BA0D@SC-VEXCH1.marvell.com>
References: <1295033760-31108-1-git-send-email-bzhao@marvell.com>
 <AANLkTi=BMTLa36FXW7nNHKu8=PgPCJC517vsmDDNZcYj@mail.gmail.com>
In-Reply-To: <AANLkTi=BMTLa36FXW7nNHKu8=PgPCJC517vsmDDNZcYj@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

> -----Original Message-----
> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> Sent: Friday, January 14, 2011 6:59 PM
> To: Bing Zhao
> Cc: linux-wireless@vger.kernel.org; John W. Linville; Johannes Berg; Amitkumar Karwar; Kiran Divekar;
> Frank Huang
> Subject: Re: [PATCH] mwifiex: remove duplicated NULL checks
> 
> On Sat, Jan 15, 2011 at 06:36, Bing Zhao <bzhao@marvell.com> wrote:
> > From: Amitkumar Karwar <akarwar@marvell.com>
> >
> > Some functions have unnecessory NULL check for an input parameter
> > because the caller to those functions is already checking the parameter
> > for NULL before calling them.
> 
> It may be more readable and efficient to eliminate the NULL checks in
> the callers - and adjust the code to inform the callers of the case
> where the pointer passed is null and make the callers to properly
> handle this case.

Thank you very much for your comments.

There are still some cases that the NULL check needs to be done at the first place. For example,


/* the caller function */
enum mwifiex_status mwifiex_prepare_cmd(struct mwifiex_private *priv,
                u16 cmd_no, u16 cmd_action, u32 cmd_oid,
		    void *ioctl_buf, void *data_buf)

	......

      cmd_node = mwifiex_get_cmd_node(adapter);

      if (cmd_node == NULL) {
              PRINTM(MERROR, "PREP_CMD: No free cmd node\n");
              ret = MWIFIEX_STATUS_FAILURE;
              goto done;
      }
	/*
	  Here the cmd_node is allocated and the NULL check is preformed
        immediately. If the pointer is NULL then the error code is
	  returned for proper handling.
	*/


	/*
	  Now cmd_node is passed to the callee as a parameter
 	*/
      mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, ioctl_buf,
                              data_buf);

	......
}

/* the callee function */
static void mwifiex_init_cmd_node(struct mwifiex_private *priv,
                      struct cmd_ctrl_node *cmd_node,
                      u32 cmd_oid, void *ioctl_buf, void *data_buf)
{
      ENTER();

-	if (cmd_node == NULL) {
-		LEAVE();
-		return;
-	}
-
	/*
	  Here it is redundant to check it again since the cmd_node
        has already been validated by the caller. 
	*/

      cmd_node->priv = priv;
      cmd_node->cmd_oid = cmd_oid;
      cmd_node->ioctl_buf = ioctl_buf;

	......
}

> 
> This should also make the driver more robust as failures can be passed
> up the stack to places that can deal with them more effectively than
> just printing a message.

I could have misunderstood your point, however. If so, could you please explain a little bit more on how you would make the changes based on above example?

Thanks in advance for your help!

Bing

> 
> Thanks,
> 
> --
> 
> Julian Calaby
> 
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
